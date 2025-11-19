--- src/desktop/Makefile	2020-04-27 18:04:29.000000000 +0000
+++ src-mod/desktop/Makefile	2020-07-05 14:29:13.280000000 +0000
@@ -62,23 +62,6 @@
 		$(INSTALL_DIR) -m 755 $(BUILDROOT)$(DBUSDIR)/system.d; \
 		$(INSTALL_DATA) cups.conf $(BUILDROOT)$(DBUSDIR)/system.d/cups.conf; \
 	fi
-	if test "x$(MENUDIR)" != x; then \
-		echo Installing desktop menu...; \
-		$(INSTALL_DIR) -m 755 $(BUILDROOT)$(MENUDIR); \
-		$(INSTALL_DATA) cups.desktop $(BUILDROOT)$(MENUDIR); \
-	fi
-	if test "x$(ICONDIR)" != x; then \
-		echo Installing desktop icons...; \
-		$(INSTALL_DIR) -m 755 $(BUILDROOT)$(ICONDIR)/hicolor/16x16/apps; \
-		$(INSTALL_DATA) cups-16.png $(BUILDROOT)$(ICONDIR)/hicolor/16x16/apps/cups.png; \
-		$(INSTALL_DIR) -m 755 $(BUILDROOT)$(ICONDIR)/hicolor/32x32/apps; \
-		$(INSTALL_DATA) cups-32.png $(BUILDROOT)$(ICONDIR)/hicolor/32x32/apps/cups.png; \
-		$(INSTALL_DIR) -m 755 $(BUILDROOT)$(ICONDIR)/hicolor/64x64/apps; \
-		$(INSTALL_DATA) cups-64.png $(BUILDROOT)$(ICONDIR)/hicolor/64x64/apps/cups.png; \
-		$(INSTALL_DIR) -m 755 $(BUILDROOT)$(ICONDIR)/hicolor/128x128/apps; \
-		$(INSTALL_DATA) cups-128.png $(BUILDROOT)$(ICONDIR)/hicolor/128x128/apps/cups.png; \
-	fi
-
 
 #
 # Install programs...
