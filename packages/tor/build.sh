TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_DEPENDS="libevent, openssl, liblzma"
TERMUX_PKG_VERSION=0.3.3.8
TERMUX_PKG_SHA256=3cf5b4fea2491cbfefa1077bf1b2855e169052d381bd920cd57aa9bfaff6b3a5
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
