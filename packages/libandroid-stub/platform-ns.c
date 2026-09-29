#include "platform-ns.h"

#include <android/dlext.h>
#include <dlfcn.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* The same directories ld.config.txt gives the default namespace of a binary
 * below /data; everything else comes in over a namespace link. */
#ifdef __LP64__
#define LIBRARY_PATH "/system/lib64:/system/system_ext/lib64"
#else
#define LIBRARY_PATH "/system/lib:/system/system_ext/lib"
#endif

/* A second copy of these in the process would be fatal, so they are imported
 * from the namespace we are running in rather than loaded again. */
#define IMPORTED_LIBRARIES "libc.so:libm.so:libdl.so:liblog.so"

/* As defined in bionic's <android/dlext_namespaces.h>, which the NDK does not
 * ship. Only the regular type is used here: unlike an isolated namespace it
 * does not restrict loading to its search paths, which keeps us out of trouble
 * on devices that keep platform libraries in less common places. */
enum {
    ANDROID_NAMESPACE_TYPE_REGULAR = 0,
    ANDROID_NAMESPACE_TYPE_ISOLATED = 1,
    ANDROID_NAMESPACE_TYPE_SHARED = 2,
};

/* Platform namespaces are named in the linker configuration; which of them
 * exist differs between Android versions, and vendors add their own. */
static const char *const linker_configs[] = {
    "/linkerconfig/ld.config.txt", /* generated at boot since Android 11 */
    "/system/etc/ld.config.txt",
};

/* The namespace API lives in the linker and is not part of the NDK, so it has
 * to be looked up at runtime. The __loader_ entry points take the caller
 * address that the libdl wrappers (gone since Android 11) passed on
 * implicitly. */
static struct android_namespace_t *(*create_namespace)(
        const char *name, const char *ld_library_path, const char *default_library_path,
        uint64_t type, const char *permitted_when_isolated_path,
        struct android_namespace_t *parent, const void *caller_addr);

static bool (*link_namespaces)(struct android_namespace_t *from,
        struct android_namespace_t *to, const char *shared_libs_sonames);

static bool (*link_all_libs)(struct android_namespace_t *from, struct android_namespace_t *to);

static struct android_namespace_t *(*get_exported_namespace)(const char *name);

/* Links every platform namespace the linker exposes to this process. The names
 * are read off the device rather than hardcoded, and the linker itself then
 * drops the ones that were not created for this process, so there is no need
 * to work out which section of the configuration applies to us. This is how a
 * library such as libandroidicu.so is reached at all: it lives in an APEX and
 * no search path leads to it. */
static void link_platform_namespaces(struct android_namespace_t *ns) {
    struct android_namespace_t *seen[64];
    unsigned n_seen = 0, i;
    char line[512];
    FILE *f = NULL;

    for (i = 0; !f && i < sizeof(linker_configs) / sizeof(*linker_configs); i++)
        f = fopen(linker_configs[i], "r");

    if (!f)
        return;

    /* Whatever it is called, never link the namespace we came from: it is the
     * one holding the Termux libraries this whole exercise is about. */
    if ((seen[0] = get_exported_namespace("default")))
        n_seen = 1;

    while (fgets(line, sizeof(line), f)) {
        struct android_namespace_t *platform;
        char name[128];
        const char *end;
        size_t length;

        /* There is one such line per namespace, and being visible is what
         * allows android_get_exported_namespace() to hand it out at all. */
        if (strncmp(line, "namespace.", 10) != 0)
            continue;
        if (!(end = strchr(line + 10, '.')))
            continue;
        if (strncmp(end, ".visible = true", 15) != 0)
            continue;

        length = end - line - 10;
        if (length >= sizeof(name))
            continue;

        memcpy(name, line + 10, length);
        name[length] = '\0';

        if (!(platform = get_exported_namespace(name)))
            continue;

        for (i = 0; i < n_seen; i++)
            if (seen[i] == platform)
                platform = NULL;

        if (platform && n_seen < sizeof(seen) / sizeof(*seen)) {
            seen[n_seen++] = platform;
            link_all_libs(ns, platform);
        }
    }

    fclose(f);
}

/* Returns the namespace the platform libraries are loaded into, or NULL if the
 * linker does not let us have one. Created on first use and shared from then
 * on, so that a process gets a single one no matter how many wrappers ask. */
static struct android_namespace_t *platform_namespace(void) {
    static struct android_namespace_t *ns;
    static bool created;

    void *linker;

    if (created)
        return ns;

    created = true;

    if (!(linker = dlopen("libdl.so", RTLD_NOW)))
        return NULL;

    create_namespace = (__typeof__(create_namespace)) dlsym(linker, "__loader_android_create_namespace");
    link_namespaces = (__typeof__(link_namespaces)) dlsym(linker, "__loader_android_link_namespaces");
    link_all_libs = (__typeof__(link_all_libs)) dlsym(linker, "__loader_android_link_namespaces_all_libs");
    get_exported_namespace = (__typeof__(get_exported_namespace)) dlsym(linker, "__loader_android_get_exported_namespace");

    /* These entry points are implemented in the linker itself, which is never
     * unloaded, so the handle is of no further use. */
    dlclose(linker);

    if (!create_namespace || !link_namespaces || !link_all_libs || !get_exported_namespace)
        return NULL;

    ns = create_namespace("termux-platform", LIBRARY_PATH, LIBRARY_PATH,
                          ANDROID_NAMESPACE_TYPE_REGULAR, NULL, NULL,
                          (const void *) &platform_namespace);
    if (!ns)
        return NULL;

    /* A NULL target namespace means the default one, i.e. ours. Without the
     * bionic core imported the namespace would load a second libc. */
    if (!link_namespaces(ns, NULL, IMPORTED_LIBRARIES)) {
        ns = NULL;
        return NULL;
    }

    link_platform_namespaces(ns);

    return ns;
}

void *platform_dlopen(const char *path, int flags) {
    struct android_namespace_t *ns = platform_namespace();
    void *handle = NULL;

    if (ns) {
        android_dlextinfo info = { .flags = ANDROID_DLEXT_USE_NAMESPACE, .library_namespace = ns };

        handle = android_dlopen_ext(path, flags, &info);
    }

    /* Whatever went wrong, without a namespace of our own the behaviour is
     * still the one the wrappers had before. */
    if (!handle)
        handle = dlopen(path, flags);

    return handle;
}
