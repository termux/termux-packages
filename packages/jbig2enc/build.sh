TERMUX_PKG_HOMEPAGE=https://github.com/agl/jbig2enc
TERMUX_PKG_DESCRIPTION="JBIG2 Encoder"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.29
TERMUX_PKG_SRCURL=https://github.com/agl/jbig2enc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280
TERMUX_PKG_DEPENDS="binutils, leptonica"
termux_step_make() {
	make prefix=$TERMUX_PREFIX
}

termux_step_make_install() {
	make install oldincludedir=$TERMUX_PREFIX/include prefix=$TERMUX_PREFIX
}
