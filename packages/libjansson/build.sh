TERMUX_PKG_HOMEPAGE=http://www.digip.org/jansson/
TERMUX_PKG_DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
TERMUX_PKG_VERSION=2.10
TERMUX_PKG_SRCURL=https://github.com/akheron/jansson/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0a899f90ade82e42da0ecabc8af1fa296d69691e7c0786c4994fb79d4833ebb
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	autoreconf -fi
}
