TERMUX_PKG_HOMEPAGE=https://keep.imfreedom.org/libgnt/libgnt
TERMUX_PKG_DESCRIPTION="An ncurses toolkit for creating text-mode graphical user interfaces in a fast and easy way"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.15.0"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/pidgin/libgnt/${TERMUX_PKG_VERSION}/libgnt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6dce3d4f2fb33c242d8223ddda5f1042f3dfb0ad7c395d4e33a73f92423a58a3
TERMUX_PKG_DEPENDS="glib, libxml2, ncurses, ncurses-ui-libs"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Ddoc=false"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
