TERMUX_PKG_HOMEPAGE='https://www.torproject.org'
TERMUX_PKG_DESCRIPTION='The Onion Router anonymizing overlay network.'
TERMUX_PKG_DEPENDS="libevent (>=2.0.22-2), openssl"
TERMUX_PKG_VERSION='0.2.8.10'
TERMUX_PKG_SRCURL="https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_CONFFILES='etc/tor/torrc'
TERMUX_PKG_SHA256='c88b8c57b34ebf44b731df5d68f73eb6b6708bcf4e42cf7b4817fd4e304c9c4d'
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'

termux_step_pre_configure () {
    LDFLAGS="$LDFLAGS -llog"
}

termux_step_post_make_install () {
    # use default config
    mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"
}
