TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/evolution/-/wikis/home
TERMUX_PKG_DESCRIPTION="Unified contacts, tasks and calendar backend"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.56.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/evolution-data-server/${TERMUX_PKG_VERSION%.*}/evolution-data-server-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=646cc0037da3f9f295794c637d95394ad76f8c9bee2268be2c4183e27720c137
TERMUX_PKG_DEPENDS="glib, gtk3, gtk4, json-glib, krb5, libcanberra, libical, libicu, libnspr, libnss, libsecret, libsoup3, libsqlite, libuuid, libxml2, openldap"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DENABLE_TESTS=OFF
-DWITH_NSPR_INCLUDES=$TERMUX_PREFIX/include/nspr
-DWITH_NSS_INCLUDES=$TERMUX_PREFIX/include/nss
-DENABLE_OAUTH2_WEBKITGTK=OFF
-DENABLE_OAUTH2_WEBKITGTK4=OFF
-DENABLE_GOA=OFF
-DENABLE_WEATHER=OFF
-DWITH_LIBDB=OFF
-DENABLE_GTK_DOC=OFF
"

termux_step_host_build() {
	touch evolution-data-server-config.h
	gcc -I. \
		"$TERMUX_PKG_SRCDIR"/src/camel/camel-gen-tables.c \
		-o camel-gen-tables
	chmod +x camel-gen-tables
	gcc -I. \
		$(pkg-config --cflags glib-2.0) \
		"$TERMUX_PKG_SRCDIR"/src/addressbook/libebook-contacts/gen-western-table.c \
		$(pkg-config --libs glib-2.0) \
		-o gen-western-table
	chmod +x gen-western-table
}

termux_step_pre_configure() {
	export SENDMAIL_PATH="$TERMUX_PREFIX/bin/sendmail"
	export GOOGLE_OAUTH2_SCHEME_SCRIPT="$TERMUX_PKG_BUILDER_DIR/google-scheme-decode.py"
	export ICONV_DETECT_H="$TERMUX_PKG_BUILDER_DIR/iconv-detect.h"

	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"

	LDFLAGS="-Wl,-rpath=$TERMUX_PREFIX/lib/evolution-data-server $LDFLAGS"
}
