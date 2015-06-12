TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_VERSION=7.42.1
TERMUX_PKG_SRCURL=http://curl.haxx.se/download/curl-${TERMUX_PKG_VERSION}.tar.bz2

export TERMUX_CA_BUNDLE=$TERMUX_PREFIX/etc/ssl/cert.pem
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl --with-ca-bundle=$TERMUX_CA_BUNDLE"
TERMUX_PKG_RM_AFTER_INSTALL="bin/curl-config share/man/man1/curl-config.1"

termux_step_post_make_install () {
	# "port install p5-libwww-perl" needed on mac:
	make ca-bundle
        mkdir -p `dirname $TERMUX_CA_BUNDLE`
	cp lib/ca-bundle.crt $TERMUX_CA_BUNDLE
}
