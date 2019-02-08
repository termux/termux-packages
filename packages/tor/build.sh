TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_DEPENDS="libevent, openssl, liblzma"
TERMUX_PKG_VERSION=0.3.5.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=1b0887fc21ac535befea7243c5d5f1e31394d7458d64b30807a3e98cca0d839e
TERMUX_PKG_SRCURL=https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-zstd --disable-unittests"
TERMUX_PKG_CONFFILES="etc/tor/torrc"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"

termux_step_pre_configure () {
	LDFLAGS="$LDFLAGS -llog"
}

termux_step_post_make_install () {
	# use default config
	mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"
}
