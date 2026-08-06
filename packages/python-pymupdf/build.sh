TERMUX_PKG_HOMEPAGE=https://github.com/pymupdf/PyMuPDF
TERMUX_PKG_DESCRIPTION="Python bindings for MuPDF's rendering library"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/pymupdf/PyMuPDF/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=20920e04b48d248454b2eb6086de26c3baff55e5d66530530174a4d4e02c0410
TERMUX_PKG_DEPENDS="freetype, gumbo-parser, harfbuzz, jbig2dec, leptonica, libc++, libjpeg-turbo, mupdf, openjpeg, python, python-mupdf, tesseract"
TERMUX_PKG_BUILD_DEPENDS="python-psutil, python-pipcl"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="libclang, swig, build, distro, installer"
TERMUX_PKG_BUILD_IN_SRC=true
# I assume it should be synchronized with mupdf
TERMUX_PKG_AUTO_UPDATE=false

termux_step_make() {
	# copied from Arch Linux
	# https://gitlab.archlinux.org/archlinux/packaging/packages/python-pymupdf/-/blob/b99cdb511539d3d09fdedc4329610ef786f1a627/PKGBUILD
	local cflags=(
		"-I$TERMUX_PREFIX/include"
		"-I$TERMUX_PREFIX/include/freetype2"
		"-I$TERMUX_PREFIX/include/harbuzz"
		"-I$TERMUX_PREFIX/include/mupdf"
	)
	local ldflags=(
		-lfreetype
		-lgumbo
		-lharfbuzz
		-ljbig2dec
		-ljpeg
		-lleptonica
		-lmupdf
		-lopenjp2
		-ltesseract
	)

	# build against system libmupdf
	export PYMUPDF_SETUP_MUPDF_BUILD=''
	export TESSDATA_PREFIX="$TERMUX_PREFIX/share/tessdata"
	export PYMUPDF_SETUP_IMPLEMENTATIONS=b

	CFLAGS+=" ${cflags[@]}"
	LDFLAGS+=" ${ldflags[@]}"

	export LD="$CC"

	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	pip install --no-deps --prefix="$TERMUX_PREFIX" --force-reinstall dist/*.whl
}
