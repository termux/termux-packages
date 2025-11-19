TERMUX_PKG_HOMEPAGE=https://python-pillow.org/
TERMUX_PKG_DESCRIPTION="Python Imaging Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.1.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/python-pillow/Pillow/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e63499468dc069a31ea0226b531be1c1c31b185b80616f8707066aba599db12
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libimagequant, libjpeg-turbo, libraqm, libtiff, libwebp, libxcb, littlecms, openjpeg, python, zlib"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	if [ ! -e "$TERMUX_PYTHON_HOME/site-packages/pillow-$TERMUX_PKG_VERSION.dist-info" ]; then
		termux_error_exit "Package ${TERMUX_PKG_NAME} doesn't build properly."
	fi
}
