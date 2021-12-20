TERMUX_PKG_HOMEPAGE=https://github.com/yshui/picom
TERMUX_PKG_DESCRIPTION="A lightweight compositor for X11"
TERMUX_PKG_LICENSE="MIT,MPL-2.0"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=8.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/yshui/picom/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d0c2533985e9670ff175e717a42b5bf1a2a00ccde5cac1e1009f5d6ee7912ec
TERMUX_PKG_DEPENDS="libx11, libxcb, xcb-util, xcb-util-image, xcb-util-renderutil, libxext, xorgproto, libpixman, dbus, libconfig, mesa, pcre, libev, uthash"

termux_step_pre_configure() {
    sed -i "s/^\(host_system *= *\).*/\1'linux'/" src/meson.build
}
