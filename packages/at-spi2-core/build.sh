TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Accessibility
TERMUX_PKG_DESCRIPTION="Assistive Technology Service Provider Interface (AT-SPI)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.54.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/at-spi2-core/${TERMUX_PKG_VERSION%.*}/at-spi2-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f0729e5c8765feb1969bb6c1fba18afa2582126b0359aa75a173fda1acf93c4c
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
}
