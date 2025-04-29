TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Accessibility
TERMUX_PKG_DESCRIPTION="Assistive Technology Service Provider Interface (AT-SPI)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.56.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/at-spi2-core/${TERMUX_PKG_VERSION%.*}/at-spi2-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e1b1c9836a8947852f7440c32e23179234c76bd98cd9cc4001f376405f8b783b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, glib, libx11, libxi, libxtst"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, libxml2"
TERMUX_PKG_PROVIDES="at-spi2-atk, atk"
TERMUX_PKG_REPLACES="at-spi2-atk (<< 2.46.0), atk (<< 2.46.0), libatk"
TERMUX_PKG_BREAKS="at-spi2-atk (<< 2.46.0), atk (<< 2.46.0), libatk"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddbus_daemon=$TERMUX_PREFIX/bin/dbus-daemon
-Dintrospection=enabled
-Dx11=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		'lib/libatk-1.0.so.0'
		'lib/libatk-bridge-2.0.so.0'
		'lib/libatspi.so.0'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}
