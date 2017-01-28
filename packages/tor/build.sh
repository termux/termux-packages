TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_DEPENDS="libevent, openssl"
TERMUX_PKG_VERSION=0.2.9.9
TERMUX_PKG_SRCURL=https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=33325d2b250fd047ba2ddc5d11c2190c4e2951f4b03ec48ebd8bf0666e990d43
TERMUX_PKG_CONFFILES="etc/tor/torrc"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"

termux_step_pre_configure () {
	LDFLAGS="$LDFLAGS -llog"
}

termux_step_post_make_install () {
	# use default config
	mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"
}
