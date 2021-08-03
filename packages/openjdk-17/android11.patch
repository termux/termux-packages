diff -uNr mobile-ec285598849a27f681ea6269342cf03cf382eb56/src/java.base/share/native/libjli/java.c mobile-ec285598849a27f681ea6269342cf03cf382eb56.mod/src/java.base/share/native/libjli/java.c
--- mobile-ec285598849a27f681ea6269342cf03cf382eb56/src/java.base/share/native/libjli/java.c	2021-07-06 14:29:24.000000000 +0300
+++ mobile-ec285598849a27f681ea6269342cf03cf382eb56.mod/src/java.base/share/native/libjli/java.c	2021-07-30 15:23:39.352949077 +0300
@@ -54,6 +54,24 @@
 #include "java.h"
 #include "jni.h"
 
+#ifdef __TERMUX__
+#include <stdbool.h>
+#include <dlfcn.h>
+static void android_disable_tags() {
+    void *lib_handle = dlopen("libc.so", RTLD_LAZY);
+    if (lib_handle) {
+        bool (*android_mallopt)(int opcode, void* arg, size_t arg_size) = dlsym(lib_handle, "android_mallopt");
+        if (android_mallopt) {
+            int android_malloc_tag_level = 0;
+            android_mallopt(8, &android_malloc_tag_level, sizeof(android_malloc_tag_level));
+        }
+        dlclose(lib_handle);
+    }
+}
+#else
+static void android_disable_tags(){}
+#endif
+
 /*
  * A NOTE TO DEVELOPERS: For performance reasons it is important that
  * the program image remain relatively small until after SelectVersion
@@ -252,6 +270,8 @@
     _is_java_args = javaargs;
     _wc_enabled = cpwildcard;
 
+    android_disable_tags();
+
     InitLauncher(javaw);
     DumpState();
     if (JLI_IsTraceLauncher()) {
