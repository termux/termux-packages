TERMUX_PKG_HOMEPAGE=https://keep.imfreedom.org/libgnt/libgnt
TERMUX_PKG_DESCRIPTION="An ncurses toolkit for creating text-mode graphical user interfaces in a fast and easy way"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.4"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/pidgin/libgnt/${TERMUX_PKG_VERSION}/libgnt-${TERMUX_PKG_VERSION}-dev.tar.xz
TERMUX_PKG_SHA256=195933a9a731d3575791b881ba5cc0ad2a715e1e9c4c23ccaaa2a17e164c96ec
TERMUX_PKG_DEPENDS="glib, libxml2, ncurses, ncurses-ui-libs"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Ddoc=false -Dpython2=false"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
