TERMUX_PKG_HOMEPAGE=http://www.mirbsd.org/jupp.htm
TERMUX_PKG_DESCRIPTION="User friendly full screen text editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1jupp41
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://anna.lysator.liu.se/pub/void-ppc-sources/jupp-${TERMUX_PKG_VERSION}/joe-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=7bb8ea8af519befefff93ec3c9e32108d7f2b83216c9bc7b01aef5098861c82f
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_CONFLICTS="joe"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dependency-tracking
--disable-getpwnam
--disable-termcap
--disable-termidx
--enable-sysconfjoesubdir=/jupp
"

termux_step_post_get_source() {
	chmod +x "$TERMUX_PKG_SRCDIR/configure"
}
