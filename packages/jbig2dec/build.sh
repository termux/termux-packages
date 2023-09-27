TERMUX_PKG_HOMEPAGE=https://jbig2dec.com/
TERMUX_PKG_DESCRIPTION="Decoder implementation of the JBIG2 image compression format"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.19
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9530/jbig2dec-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=279476695b38f04939aa59d041be56f6bade3422003a406a85e9792c27118a37
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_BREAKS="jbig2dec-dev"
TERMUX_PKG_REPLACES="jbig2dec-dev"

termux_step_pre_configure() {
	./autogen.sh
}
