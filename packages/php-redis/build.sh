TERMUX_PKG_HOMEPAGE=https://github.com/phpredis/phpredis
TERMUX_PKG_DESCRIPTION="PHP extension for interfacing with Redis"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/phpredis/phpredis/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f5cda93aac8c1c4bafa45255460292571fb2f029b0ac4a5a4dc66987a9529e6
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
