TERMUX_PKG_HOMEPAGE=https://libexpat.github.io/
TERMUX_PKG_DESCRIPTION="XML parsing C library"
TERMUX_PKG_VERSION=2.2.5
TERMUX_PKG_SHA256=d9dc32efba7e74f788fcc4f212a43216fc37cf5f23f4c2339664d473353aedf6
TERMUX_PKG_SRCURL=https://github.com/libexpat/libexpat/releases/download/R_${TERMUX_PKG_VERSION//./_}/expat-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-xmlwf"
