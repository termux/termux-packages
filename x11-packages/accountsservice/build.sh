TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/accountsservice/accountsservice/
TERMUX_PKG_DESCRIPTION="D-Bus interface for user account query and manipulation"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="23.13.9"
TERMUX_PKG_SRCURL="https://www.freedesktop.org/software/accountsservice/accountsservice-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=adda4cdeae24fa0992e7df3ffff9effa7090be3ac233a3edfdf69d5a9c9b924f
TERMUX_PKG_DEPENDS="consolekit2, dbus, glib, gobject-introspection, libcrypt, polkit"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dconsolekit=true
-Dintrospection=true
-Dvapi=false
-Dtests=false
-Dsystemdsystemunitdir=no
-Dpath_wtmp=/dev/null
-Dinstall_policy=false
"

termux_step_post_get_source() {
	echo "#!/usr/bin/env sh" > generate-version.sh
	echo "echo \"$TERMUX_PKG_VERSION\"" >> generate-version.sh
	chmod +x generate-version.sh
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
