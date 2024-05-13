TERMUX_PKG_HOMEPAGE=http://t-sato.in.coocan.jp/xvkbd/
TERMUX_PKG_DESCRIPTION="Virtual keyboard for X window system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://t-sato.in.coocan.jp/xvkbd/xvkbd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=952d07df0fe1e45286520b7c98b4fd00fd60dbf3e3e8ff61e12c259f76a3bef4
TERMUX_PKG_DEPENDS="libx11, libxaw, libxmu, libxt, libxtst"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true
