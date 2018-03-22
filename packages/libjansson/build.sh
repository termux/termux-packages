TERMUX_PKG_HOMEPAGE=http://www.digip.org/jansson/
TERMUX_PKG_DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
TERMUX_PKG_VERSION=2.11
TERMUX_PKG_SHA256=6ff0eab3a8baf64d21cae25f88a0311fb282006eb992080722a9099469c32881
TERMUX_PKG_SRCURL=https://github.com/akheron/jansson/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	autoreconf -fi
}
