#include "libintl.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdint.h>

#define LIBINTL_MAX_DOMAINS 32

typedef struct {
    char domain[64];
    char path[256];
} DomainBinding;

static DomainBinding g_bindings[LIBINTL_MAX_DOMAINS];
static int g_binding_count = 0;
static char g_current_domain[64] = "messages";

char *bindtextdomain(const char *domainname, const char *dirname) {
    if (!domainname || !*domainname) return NULL;
    for (int i = 0; i < g_binding_count; i++) {
        if (strcmp(g_bindings[i].domain, domainname) == 0) {
            if (dirname) strncpy(g_bindings[i].path, dirname, sizeof(g_bindings[i].path) - 1);
            return g_bindings[i].path;
        }
    }
    if (g_binding_count < LIBINTL_MAX_DOMAINS) {
        strncpy(g_bindings[g_binding_count].domain, domainname, sizeof(g_bindings[g_binding_count].domain) - 1);
        strncpy(g_bindings[g_binding_count].path, dirname ? dirname : "/data/data/com.termux/files/usr/share/locale", sizeof(g_bindings[g_binding_count].path) - 1);
        return g_bindings[g_binding_count++].path;
    }
    return NULL;
}

char *textdomain(const char *domainname) {
    if (domainname && *domainname) {
        strncpy(g_current_domain, domainname, sizeof(g_current_domain) - 1);
    }
    return g_current_domain;
}

char *bind_textdomain_codeset(const char *domainname, const char *codeset) {
    return (char *) (codeset ? codeset : "UTF-8");
}

static const char *get_lang(void) {
    const char *env = getenv("LC_ALL");
    if (!env || !*env) env = getenv("LC_MESSAGES");
    if (!env || !*env) env = getenv("LANG");
    if (!env || !*env) return "C";
    return env;
}

struct mo_header {
    uint32_t magic;
    uint32_t revision;
    uint32_t num_strings;
    uint32_t orig_table_offset;
    uint32_t trans_table_offset;
    uint32_t hash_table_size;
    uint32_t hash_table_offset;
};

struct string_desc {
    uint32_t length;
    uint32_t offset;
};

char *dgettext(const char *domainname, const char *msgid) {
    if (!msgid) return NULL;
    if (!domainname) domainname = g_current_domain;
    if (!domainname || !*domainname) domainname = "messages";

    const char *lang_env = get_lang();
    if (strncmp(lang_env, "C", 1) == 0 || strncmp(lang_env, "en", 2) == 0) {
        return (char *) msgid;
    }

    char lang[16];
    strncpy(lang, lang_env, sizeof(lang) - 1);
    lang[sizeof(lang) - 1] = '\0';
    char *dot = strchr(lang, '.');
    if (dot) *dot = '\0';

    const char *base_dir = "/data/data/com.termux/files/usr/share/locale";
    for (int i = 0; i < g_binding_count; i++) {
        if (strcmp(g_bindings[i].domain, domainname) == 0) {
            base_dir = g_bindings[i].path;
            break;
        }
    }

    char mo_path[512];
    snprintf(mo_path, sizeof(mo_path), "%s/%s/LC_MESSAGES/%s.mo", base_dir, lang, domainname);

    int fd = open(mo_path, O_RDONLY);
    if (fd < 0) {
        char *underscore = strchr(lang, '_');
        if (underscore) {
            *underscore = '\0';
            snprintf(mo_path, sizeof(mo_path), "%s/%s/LC_MESSAGES/%s.mo", base_dir, lang, domainname);
            fd = open(mo_path, O_RDONLY);
        }
    }
    if (fd < 0) {
        char short_lang[8];
        strncpy(short_lang, lang, sizeof(short_lang) - 1);
        short_lang[sizeof(short_lang) - 1] = '\0';
        char *underscore = strchr(short_lang, '_');
        if (underscore) {
            *underscore = '\0';
            snprintf(mo_path, sizeof(mo_path), "%s/%s/LC_MESSAGES/%s.mo", base_dir, short_lang, domainname);
            fd = open(mo_path, O_RDONLY);
        }
    }

    if (fd < 0) return (char *) msgid;

    struct stat st;
    if (fstat(fd, &st) < 0 || st.st_size < (off_t)sizeof(struct mo_header)) {
        close(fd);
        return (char *) msgid;
    }

    void *data = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);
    if (data == MAP_FAILED) return (char *) msgid;

    struct mo_header *hdr = (struct mo_header *) data;
    if (hdr->magic != 0x950412de) {
        munmap(data, st.st_size);
        return (char *) msgid;
    }

    struct string_desc *orig_table = (struct string_desc *) ((char *) data + hdr->orig_table_offset);
    struct string_desc *trans_table = (struct string_desc *) ((char *) data + hdr->trans_table_offset);

    char *result = (char *) msgid;
    uint32_t msgid_len = strlen(msgid);

    /* 1. Try exact match */
    for (uint32_t i = 0; i < hdr->num_strings; i++) {
        if (orig_table[i].length == msgid_len) {
            const char *orig_str = (const char *) data + orig_table[i].offset;
            if (memcmp(orig_str, msgid, msgid_len) == 0) {
                const char *trans = (const char *) data + trans_table[i].offset;
                if (trans && *trans) {
                    result = (char *) trans;
                }
                break;
            }
        }
    }

    /* 2. Try matching without context if msgid didn't contain \004 */
    if (result == msgid && strchr(msgid, '\004') == NULL) {
        for (uint32_t i = 0; i < hdr->num_strings; i++) {
            const char *orig_str = (const char *) data + orig_table[i].offset;
            const char *sep = strchr(orig_str, '\004');
            if (sep && strcmp(sep + 1, msgid) == 0) {
                const char *trans = (const char *) data + trans_table[i].offset;
                if (trans && *trans) {
                    result = (char *) trans;
                }
                break;
            }
        }
    }

    if (result != msgid) {
        result = strdup(result);
    }

    munmap(data, st.st_size);
    return result;
}

char *gettext(const char *msgid) {
    return dgettext(NULL, msgid);
}

char *dcgettext(const char *domainname, const char *msgid, int category) {
    return dgettext(domainname, msgid);
}

char *ngettext(const char *msgid1, const char *msgid2, unsigned long int n) {
    return (char *) (n == 1 ? gettext(msgid1) : gettext(msgid2));
}

char *dngettext(const char *domainname, const char *msgid1, const char *msgid2, unsigned long int n) {
    return (char *) (n == 1 ? dgettext(domainname, msgid1) : dgettext(domainname, msgid2));
}

char *dcngettext(const char *domainname, const char *msgid1, const char *msgid2, unsigned long int n, int category) {
    return dngettext(domainname, msgid1, msgid2, n);
}

/* GLib & GTK compatibility functions matching glib/ggettext.h signatures */
const char *g_dgettext(const char *domainname, const char *msgid) {
    return dgettext(domainname, msgid);
}

const char *g_dcgettext(const char *domainname, const char *msgid, int category) {
    return dcgettext(domainname, msgid, category);
}

const char *g_dngettext(const char *domainname, const char *msgid1, const char *msgid2, unsigned long int n) {
    return dngettext(domainname, msgid1, msgid2, n);
}

const char *g_dpgettext(const char *domainname, const char *msgctxtid, size_t msgidoffset) {
    return dgettext(domainname, msgctxtid);
}

const char *g_dpgettext2(const char *domainname, const char *msgctxt, const char *msgid) {
    if (!msgctxt || !*msgctxt) return dgettext(domainname, msgid);
    size_t ctxt_len = strlen(msgctxt);
    size_t id_len = strlen(msgid);
    char *buf = malloc(ctxt_len + 1 + id_len + 1);
    if (!buf) return msgid;
    memcpy(buf, msgctxt, ctxt_len);
    buf[ctxt_len] = '\004';
    memcpy(buf + ctxt_len + 1, msgid, id_len + 1);
    const char *res = dgettext(domainname, buf);
    if (res == buf) {
        free(buf);
        return msgid;
    }
    free(buf);
    return res;
}

char *libintl_gettext(const char *msgid) { return gettext(msgid); }
char *libintl_dgettext(const char *domainname, const char *msgid) { return dgettext(domainname, msgid); }
char *libintl_dcgettext(const char *domainname, const char *msgid, int category) { return dcgettext(domainname, msgid, category); }
char *libintl_ngettext(const char *msgid1, const char *msgid2, unsigned long int n) { return ngettext(msgid1, msgid2, n); }
char *libintl_dngettext(const char *domainname, const char *msgid1, const char *msgid2, unsigned long int n) { return dngettext(domainname, msgid1, msgid2, n); }
char *libintl_dcngettext(const char *domainname, const char *msgid1, const char *msgid2, unsigned long int n, int category) { return dcngettext(domainname, msgid1, msgid2, n, category); }
char *libintl_textdomain(const char *domainname) { return textdomain(domainname); }
char *libintl_bindtextdomain(const char *domainname, const char *dirname) { return bindtextdomain(domainname, dirname); }
char *libintl_bind_textdomain_codeset(const char *domainname, const char *codeset) { return bind_textdomain_codeset(domainname, codeset); }
