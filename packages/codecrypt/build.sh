TERMUX_PKG_HOMEPAGE=http://e-x-a.org/codecrypt/
TERMUX_PKG_DESCRIPTION="The post-quantum cryptography tool"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://github.com/exaexa/codecrypt/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=25f11bc361b4f8aca7245698334b5715b7d594d708a75e8cdb2aa732dc46eb96
TERMUX_PKG_DEPENDS="cryptopp, fftw, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-cryptopp"

termux_step_pre_configure() {
	./autogen.sh
	export LIBS="-lm"
	export CRYPTOPP_CFLAGS="-I$TERMUX_PREFIX/include"
	export CRYPTOPP_LIBS="-L$TERMUX_PREFIX/lib -lcryptopp"
}
