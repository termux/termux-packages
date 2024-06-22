--- node-v18.10.0/test/common/index.js	2022-09-28 20:36:06.000000000 +0530
+++ node-v18.10.0.mod/test/common/index.js	2022-10-06 10:31:06.867469751 +0530
@@ -120,6 +120,11 @@
 const isOpenBSD = process.platform === 'openbsd';
 const isLinux = process.platform === 'linux';
 const isOSX = process.platform === 'darwin';
+// The regex inside the function causes test-startup-empty-regexp-statics.js
+// to break. Probably not something Termux specific, but don't know why anyone
+// else hasn't complaint upstream
+const isPi = false;
+/* 
 const isPi = (() => {
   try {
     // Normal Raspberry Pi detection is to find the `Raspberry Pi` string in
@@ -130,7 +135,7 @@
   } catch {
     return false;
   }
-})();
+})(); */
 
 const isDumbTerminal = process.env.TERM === 'dumb';
 
