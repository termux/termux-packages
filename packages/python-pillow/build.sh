TERMUX_PKG_HOMEPAGE=https://python-pillow.org/
TERMUX_PKG_DESCRIPTION="Python Imaging Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/python-pillow/Pillow/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fe695f6fa8bbc341b9044b6553a32d84cf6d6ea0de104396aece85e454c7cbc2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libimagequant, libjpeg-turbo, libraqm, libtiff, libwebp, libxcb, littlecms, openjpeg, python, zlib"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, 'setuptools==67.8'"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	if [ ! -e "$TERMUX_PYTHON_HOME/site-packages/pillow-$TERMUX_PKG_VERSION.dist-info" ]; then
		termux_error_exit "Package ${TERMUX_PKG_NAME} doesn't build properly."
	fi
}
