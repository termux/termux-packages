TERMUX_PKG_HOMEPAGE=https://saitoha.github.io/libsixel/
TERMUX_PKG_DESCRIPTION="Encoder/decoder implementation for DEC SIXEL graphics"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.8.6
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/saitoha/libsixel/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=37611d60c7dbcee701346967336dbf135fdd5041024d5f650d52fae14c731ab9
TERMUX_PKG_DEPENDS="libcurl, libjpeg-turbo, libpng"
TERMUX_PKG_BREAKS="libsixel-dev"
TERMUX_PKG_REPLACES="libsixel-dev"

termux_step_pre_configure() {
	export PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	export PYTHON=python$PYTHON_VERSION
	TERMUX_PKG_RM_AFTER_INSTALL="lib/${PYTHON}/site-packages/libsixel/__pycache__"
}
