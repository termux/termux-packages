TERMUX_PKG_HOMEPAGE=http://elinks.or.cz
TERMUX_PKG_DESCRIPTION="Full-Featured Text WWW Browser"
TERMUX_PKG_VERSION=0.12pre6
TERMUX_PKG_BUILD_REVISION=3
# TERMUX_PKG_SRCURL=http://elinks.or.cz/download/elinks-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/universe/e/elinks/elinks_0.12~pre6.orig.tar.gz
TERMUX_PKG_FOLDERNAME=elinks-0.12pre6
TERMUX_PKG_DEPENDS="libexpat, libidn, openssl, libbz2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-256-colors --with-openssl --mandir=$TERMUX_PREFIX/share/man --without-gc"
TERMUX_MAKE_PROCESSES=1
