TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.7.15"
TERMUX_PKG_SRCURL=https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d43b42d4249fe4b97be1248a7dc79c95f13e72f2518921a414d312c7938bf2a1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libevent, liblzma, openssl, resolv-conf, zlib"
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-zstd --disable-unittests"
TERMUX_PKG_CONFFILES="etc/tor/torrc"
TERMUX_PKG_SERVICE_SCRIPT=("tor" 'exec tor 2>&1')

termux_step_post_make_install() {
	# use default config
	mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"
}
