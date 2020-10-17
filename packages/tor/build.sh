TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=0.4.4.5
TERMUX_PKG_SRCURL=https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a45ca00afe765e3baa839767c9dd6ac9a46dd01720a3a8ff4d86558c12359926
TERMUX_PKG_DEPENDS="libevent, openssl, liblzma, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-zstd --disable-unittests"
TERMUX_PKG_CONFFILES="etc/tor/torrc"
TERMUX_PKG_SERVICE_SCRIPT=("tor" 'exec tor 2>&1')

termux_step_post_make_install() {
	# use default config
	mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"
}
