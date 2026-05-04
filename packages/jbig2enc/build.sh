TERMUX_PKG_HOMEPAGE=https://github.com/agl/jbig2enc
TERMUX_PKG_DESCRIPTION="An encoder for JBIG2"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.31"
TERMUX_PKG_SRCURL="https://github.com/agl/jbig2enc/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=35c255e44a9b1c4cbe27d2c84594a43d6666645156a2d186ba60f8832566141d
TERMUX_PKG_DEPENDS="giflib, leptonica, libc++, libjpeg-turbo, libpng, libtiff, libwebp, python, zlib"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	sh autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
