TERMUX_PKG_HOMEPAGE=https://github.com/drscream/lemonbar-xft
TERMUX_PKG_DESCRIPTION="Lightweight status bar with Xft support"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="Muhammad <nurmuhammedjoy@gmail.com>"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=https://github.com/drscream/lemonbar-xft/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9b102cb991c5e6a71541b028301e8deb6959fd112a3a32e1572dbdf3d451ee4

TERMUX_PKG_DEPENDS="libx11,libxcb,libxft"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    sed -i "s|/usr/include/freetype2|$TERMUX_PREFIX/include/freetype2|g" Makefile
    sed -i "s|PREFIX?=/usr|PREFIX?=$TERMUX_PREFIX|g" Makefile
}

termux_step_make() {
    make CC="$CC" PREFIX="$TERMUX_PREFIX"
}

termux_step_make_install() {
    make PREFIX="$TERMUX_PREFIX" install
}
