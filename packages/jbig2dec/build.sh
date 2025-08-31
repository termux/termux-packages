TERMUX_PKG_HOMEPAGE=https://jbig2dec.com/
TERMUX_PKG_DESCRIPTION="Decoder implementation of the JBIG2 image compression format"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/jbig2dec/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a9705369a6633aba532693450ec802c562397e1b824662de809ede92f67aff21
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_BREAKS="jbig2dec-dev"
TERMUX_PKG_REPLACES="jbig2dec-dev"

termux_step_pre_configure() {
	./autogen.sh
}
