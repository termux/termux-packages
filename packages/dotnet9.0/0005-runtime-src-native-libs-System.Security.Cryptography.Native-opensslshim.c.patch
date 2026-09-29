--- a/src/runtime/src/native/libs/System.Security.Cryptography.Native/opensslshim.c
+++ b/src/runtime/src/native/libs/System.Security.Cryptography.Native/opensslshim.c
@@ -77,14 +77,6 @@ static void OpenLibraryOnce(void)
         DlOpen(soName);
     }
 
-#ifdef TARGET_ANDROID
-    if (libssl == NULL)
-    {
-        // Android OpenSSL has no soname
-        DlOpen(LIBNAME);
-    }
-#endif
-
     if (libssl == NULL)
     {
         // Prefer OpenSSL 3.x
