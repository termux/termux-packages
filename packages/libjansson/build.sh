TERMUX_PKG_HOMEPAGE=http://www.digip.org/jansson/
TERMUX_PKG_DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
TERMUX_PKG_VERSION=2.10
TERMUX_PKG_SRCURL=https://github.com/akheron/jansson/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_MAINTAINER="Fredrik Fornwall @fornwall"

termux_step_preconfigure(){
  autoreconf -i
}
