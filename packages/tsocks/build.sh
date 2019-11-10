TERMUX_PKG_HOMEPAGE=http://tsocks.sf.net
TERMUX_PKG_DESCRIPTION="transparent network access through a SOCKS 4 or 5 proxy"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.8beta5
TERMUX_PKG_REVISION=3
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/tsocks/tsocks/1.8%20beta%205/tsocks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=849d7ef5af80d03e76cc05ed9fb8fa2bcc2b724b51ebfd1b6be11c7863f5b347
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-conf=$TERMUX_PREFIX/etc/tsocks.conf"

termux_step_post_extract_package() {
	cp $TERMUX_PKG_SRCDIR/tsocks-1.8/* $TERMUX_PKG_SRCDIR/
}

termux_step_pre_configure() {
	cp $TERMUX_PKG_SRCDIR/tsocks.conf.complex.example $TERMUX_PREFIX/etc/tsocks.conf
}
