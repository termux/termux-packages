TERMUX_PKG_HOMEPAGE=https://github.com/yshui/picom
TERMUX_PKG_DESCRIPTION="A lightweight compositor for X11"
TERMUX_PKG_LICENSE="MIT, MPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSES/MIT, LICENSES/MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13"
TERMUX_PKG_SRCURL=https://github.com/yshui/picom/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db9791a54255742c924ef82a6a882042636d61de0fa61bc14c5e56279cf5791c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, libconfig, libepoxy, libev, libpixman, libx11, libxcb, opengl, pcre2, xcb-util-image, xcb-util-renderutil"
TERMUX_PKG_BUILD_DEPENDS="uthash, xorgproto"
TERMUX_PKG_CONFFILES="
etc/xdg/picom.conf
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwith_docs=true
"

termux_step_pre_configure() {
	sed -i "s/^\(host_system *= *\).*/\1'linux'/" src/meson.build
}

termux_step_post_make_install() {
	install -Dm600 "${TERMUX_PKG_SRCDIR}"/picom.sample.conf "${TERMUX_PREFIX}"/etc/xdg/picom.conf
}
