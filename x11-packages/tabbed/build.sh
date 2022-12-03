TERMUX_PKG_HOMEPAGE=https://tools.suckless.org/tabbed/
TERMUX_PKG_DESCRIPTION="Generic tabbed interface"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7
TERMUX_PKG_SRCURL=https://dl.suckless.org/tools/tabbed-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6e8682230a213d7dabf8a79306bd3ce023875b2295a9097db427d65c1c68f322
TERMUX_PKG_DEPENDS="libx11, libxft"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	if [ ! -e ./xembed.1 ]; then
		cp $TERMUX_PKG_BUILDER_DIR/xembed.1 ./
	fi
}
