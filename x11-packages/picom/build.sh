TERMUX_PKG_HOMEPAGE=https://github.com/yshui/picom
TERMUX_PKG_DESCRIPTION="A lightweight compositor for X11"
TERMUX_PKG_LICENSE="MIT, MPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSES/MIT, LICENSES/MPL-2.0"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=10.2
TERMUX_PKG_SRCURL=https://github.com/yshui/picom/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9741577df0136d8a2be48005ca2b93edc15913528e19bceb798535ca4683341c
TERMUX_PKG_DEPENDS="dbus, libconfig, libev, libpixman, libx11, libxcb, mesa, pcre, xcb-util-image, xcb-util-renderutil"
TERMUX_PKG_BUILD_DEPENDS="uthash, xorgproto"

termux_step_pre_configure() {
	sed -i "s/^\(host_system *= *\).*/\1'linux'/" src/meson.build
}
