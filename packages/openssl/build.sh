TERMUX_PKG_HOMEPAGE=https://www.openssl.org/
TERMUX_PKG_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
TERMUX_PKG_DEPENDS="ca-certificates"
TERMUX_PKG_VERSION=1.0.2e
TERMUX_PKG_SRCURL="http://www.openssl.org/source/openssl-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_RM_AFTER_INSTALL="bin/c_rehash etc/ssl/misc"
TERMUX_PKG_BUILD_IN_SRC=yes

# Information about compilation and installation of openssl:
# http://wiki.openssl.org/index.php/Compilation_and_Installation

termux_step_configure () {
	perl -p -i -e "s@TERMUX_CFLAGS@$CFLAGS@g" Configure
	rm -Rf $TERMUX_PREFIX/lib/libcrypto.* $TERMUX_PREFIX/lib/libssl.*
	TERMUX_OPENSSL_PLATFORM_SUFFIX=""
        test $TERMUX_ARCH = "arm" && TERMUX_OPENSSL_PLATFORM_SUFFIX="-armv7"
        test $TERMUX_ARCH = "i686" && TERMUX_OPENSSL_PLATFORM_SUFFIX="-x86"
        # If enabling zlib-dynamic we need "zlib-dynamic" instead of "no-comp no-dso":
	./Configure android$TERMUX_OPENSSL_PLATFORM_SUFFIX --prefix=$TERMUX_PREFIX \
		--openssldir=$TERMUX_PREFIX/etc/tls \
		shared \
                no-comp no-dso \
                no-ssl2 no-hw no-engines no-psk no-srp
}

termux_step_make () {
        make depend
        make -j 1 all
}

termux_step_make_install () {
        # "install_sw" instead of "install" to not install man pages
	make -j 1 install_sw MANDIR=$TERMUX_PREFIX/share/man MANSUFFIX=.ssl
}
