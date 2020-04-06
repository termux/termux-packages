TERMUX_PKG_HOMEPAGE=https://jbig2dec.com/
TERMUX_PKG_DESCRIPTION="Decoder implementation of the JBIG2 image compression format"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.18
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs952/jbig2dec-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9e19775237350e299c422b7b91b0c045e90ffa4ba66abf28c8fb5eb005772f5e
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_BREAKS="jbig2dec-dev"
TERMUX_PKG_REPLACES="jbig2dec-dev"

termux_step_pre_configure() {
	./autogen.sh
}
