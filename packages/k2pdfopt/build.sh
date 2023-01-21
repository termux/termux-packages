TERMUX_PKG_HOMEPAGE=https://www.willus.com/k2pdfopt/
TERMUX_PKG_DESCRIPTION="A tool that optimizes PDF files for viewing on mobile readers"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.54
TERMUX_PKG_SRCURL=https://www.willus.com/k2pdfopt/src/k2pdfopt_v${TERMUX_PKG_VERSION}_src.zip
TERMUX_PKG_SHA256=43490a55bdaecdd2300276221b6a713b754e7c617e80481191c04c67b3357b38
TERMUX_PKG_DEPENDS="djvulibre, gsl, leptonica, libjasper, libjpeg-turbo, libpng, mupdf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DHAVE_MUPDF_LIB=1"
	LDFLAGS+=" -lmupdf"
}
