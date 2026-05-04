TERMUX_PKG_HOMEPAGE=https://python-pillow.org/
TERMUX_PKG_DESCRIPTION="Python Imaging Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="12.2.0"
TERMUX_PKG_SRCURL="https://github.com/python-pillow/Pillow/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=15d08a03e16953813045ad24c5818e2909ef2141a0b97b2bd3bc8ec6f222cadb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libavif, libimagequant, libjpeg-turbo, libraqm, libtiff, libwebp, libxcb, littlecms, openjpeg, python, python-pip, zlib"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	if [[ ! -e "$TERMUX_PYTHON_HOME/site-packages/pillow-$TERMUX_PKG_VERSION.dist-info" ]]; then
		termux_error_exit "Package ${TERMUX_PKG_NAME} doesn't build properly."
	fi
}
