TERMUX_PKG_HOMEPAGE=https://github.com/Imagick/imagick
TERMUX_PKG_DESCRIPTION="The Imagick PHP extension"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION=3.5.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/Imagick/imagick/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a70ccb298bb1f76d01e028d60cdfc787ffc14ab8355f61317e537f8c2a75c509
TERMUX_PKG_DEPENDS="php, imagemagick"

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
