TERMUX_PKG_HOMEPAGE=https://gitlab.com/timvisee/ffsend
TERMUX_PKG_DESCRIPTION="A fully featured Firefox Send client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.2.62
TERMUX_PKG_SRCURL=https://gitlab.com/timvisee/ffsend/-/archive/v$TERMUX_PKG_VERSION/ffsend-v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=be8227f7b7ed3f3cc914a8dc24ab0d7cb155dfda65df35be23ac5b1b443a0f72
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features --features send3,crypto-ring,history,archive,qrcode,urlshorten,infer-command"
