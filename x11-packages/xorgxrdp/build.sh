TERMUX_PKG_HOMEPAGE=https://github.com/neutrinolabs/xorgxrdp
TERMUX_PKG_DESCRIPTION="Xorg drivers for xrdp"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=0.9.19
TERMUX_PKG_SRCURL="https://github.com/neutrinolabs/xorgxrdp/releases/download/v${TERMUX_PKG_VERSION}/xorgxrdp-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c1cf4c583c28a24ce814c147d387b8f4d255877f2e365372c69c6f076ddb1455

#i686 disabled because xorg-server is not available

TERMUX_PKG_BLACKLISTED_ARCHES="i686"

TERMUX_PKG_DEPENDS="xorg-server, xrdp, libxfont2"
TERMUX_PKG_BUILD_DEPENDS="nasm, xorgproto"

termux_step_make_install(){
  make DESTDIR=$TERMUX_PREFIX install
}
