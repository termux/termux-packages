TERMUX_PKG_HOMEPAGE=https://github.com/yshui/picom
TERMUX_PKG_DESCRIPTION="A lightweight compositor for X11"
TERMUX_PKG_LICENSE="MIT, MPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSES/MIT, LICENSES/MPL-2.0"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=10.1
TERMUX_PKG_SRCURL=https://github.com/yshui/picom/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92f32bfd14fba925918b084ab6d1f88881b3586e3c8cb71361d0948f0cfd34ad
TERMUX_PKG_DEPENDS="dbus, libconfig, libev, libpixman, libx11, libxcb, pcre, xcb-util-image, xcb-util-renderutil"
TERMUX_PKG_BUILD_DEPENDS="libxext, uthash, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dopengl=false
"

termux_step_pre_configure() {
	sed -i "s/^\(host_system *= *\).*/\1'linux'/" src/meson.build
}
