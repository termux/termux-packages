TERMUX_PKG_HOMEPAGE=https://github.com/agl/jbig2enc
TERMUX_PKG_DESCRIPTION="An encoder for JBIG2"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.32"
TERMUX_PKG_SRCURL="https://github.com/agl/jbig2enc/archive/refs/tags/${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=5b3b1c48617e5b1608f916a78038ea867a2c9eb20c2ff34a78a48a243f655c2a
TERMUX_PKG_DEPENDS="giflib, leptonica, libc++, libjpeg-turbo, libpng, libtiff, libwebp, python, zlib"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	sh autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
