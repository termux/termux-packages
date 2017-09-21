TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_DEPENDS="libevent, openssl"
TERMUX_PKG_VERSION=0.3.1.7
TERMUX_PKG_SHA256=1df5dd4894bb2f5e0dc96c466955146353cf33ac50cd997cfc1b28ea3ed9c08f
TERMUX_PKG_SRCURL=https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_CONFFILES="etc/tor/torrc"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"

termux_step_pre_configure () {
	LDFLAGS="$LDFLAGS -llog"
}

termux_step_post_make_install () {
	# use default config
	mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"
}
