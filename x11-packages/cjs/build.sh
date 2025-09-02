TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cjs
TERMUX_PKG_DESCRIPTION="JavaScript Bindings for Cinnamon"
TERMUX_PKG_LICENSE="MIT, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="128.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cjs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d3432dd2722eef65b4a36db430824882b3bd90b4db469f576ff087d045e022ca
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, libx11, readline, spidermonkey"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Db_pch=false
-Dinstalled_tests=false
-Dskip_dbus_tests=true
-Dskip_gtk_tests=true
-Dskip_tests=true
"

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -f subprojects/*.wrap
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
