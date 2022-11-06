TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xorg/util/bdftopcf
TERMUX_PKG_DESCRIPTION="convert X font from Bitmap Distribution Format to Portable Compiled Format"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xorg/util/bdftopcf/-/archive/bdftopcf-${TERMUX_PKG_VERSION}/bdftopcf-bdftopcf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cd8510d3db57aa999bbc7abc30b6f60d7a685e3344eba662db685747779cb25b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xorgproto, libx11, xorg-util-macros"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
