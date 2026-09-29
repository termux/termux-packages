TERMUX_PKG_HOMEPAGE=https://tools.suckless.org/tabbed/
TERMUX_PKG_DESCRIPTION="Generic tabbed interface"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9"
TERMUX_PKG_SRCURL=https://dl.suckless.org/tools/tabbed-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0acf87457b7419e66fbfa3a9cec95ffb46d254c6b88b5e4bb7cc18c3a92008a8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxft"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	if [ ! -e ./xembed.1 ]; then
		cp $TERMUX_PKG_BUILDER_DIR/xembed.1 ./
	fi
}
