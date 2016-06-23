TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Util-linux
TERMUX_PKG_DESCRIPTION="Miscellaneous system utilities"
TERMUX_PKG_VERSION=2.28
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/util-linux/v${TERMUX_PKG_VERSION}/util-linux-${TERMUX_PKG_VERSION}.tar.xz
#TERMUX_PKG_DEPENDS="pcre, openssl, libuuid, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-last --disable-ipcrm --disable-ipcs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-eject --disable-switch_root --disable-pivot_root"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-logger --disable-agetty --disable-kill"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-wall"

CPPFLAGS+=" -DMAXNAMLEN=NAME_MAX"
