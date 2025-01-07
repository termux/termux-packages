TERMUX_PKG_HOMEPAGE=https://tools.suckless.org/tabbed/
TERMUX_PKG_DESCRIPTION="Generic tabbed interface"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8"
TERMUX_PKG_SRCURL=https://dl.suckless.org/tools/tabbed-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95bdffccb071083068d2b555c2524e9c7c57c9b64494d46c697e678d49a0a3d7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxft"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	if [ ! -e ./xembed.1 ]; then
		cp $TERMUX_PKG_BUILDER_DIR/xembed.1 ./
	fi
}
