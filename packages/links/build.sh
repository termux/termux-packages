TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser."
TERMUX_PKG_VERSION=2.15
TERMUX_PKG_MAINTAINER="lokesh @hax4us"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_SHA256=677f594b58dc532e63913cd61b85cc1aa6f0385e333b88766eb3415b41b3a375
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --mandir=$TERMUX_PREFIX/share/man"
