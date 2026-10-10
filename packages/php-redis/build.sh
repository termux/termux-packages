TERMUX_PKG_HOMEPAGE=https://github.com/phpredis/phpredis
TERMUX_PKG_DESCRIPTION="PHP extension for interfacing with Redis"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.3.0RC1+really6.3.0"
TERMUX_PKG_SRCURL=https://github.com/phpredis/phpredis/archive/refs/tags/${TERMUX_PKG_VERSION#*really}.tar.gz
TERMUX_PKG_REPOLOGY_METADATA_VERSION="${TERMUX_PKG_VERSION#*really}"
TERMUX_PKG_SHA256=cb8f81df1a275599e4f8ddcfec7e1f65ed1953e6f5673649149fd680ebff4cad
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+\.\d+\.\d+$'


termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
