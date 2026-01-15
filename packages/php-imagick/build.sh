# Contributor: @ian4hu
TERMUX_PKG_HOMEPAGE=https://github.com/Imagick/imagick
TERMUX_PKG_DESCRIPTION="The Imagick PHP extension"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION="3.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Imagick/imagick/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0e9279ddf6e75a8c6b4068e16daec0475427dbca7ce2e144e30a51a88aa5ddc
TERMUX_PKG_DEPENDS="php, imagemagick"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+\.\d+\.\d+$'

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize

	if [ "$TERMUX_ARCH_BITS" = 32 ]; then
		LDFLAGS+=" -lm"
	fi
}
