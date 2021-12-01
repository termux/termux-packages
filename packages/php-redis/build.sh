TERMUX_PKG_HOMEPAGE=https://github.com/phpredis/phpredis
TERMUX_PKG_DESCRIPTION="PHP extension for interfacing with Redis"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/phpredis/phpredis/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c0df53dc4e8cd2921503fefa224cfd51de7f74561324a6d3c66f30d4016178b3
TERMUX_PKG_DEPENDS=php

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
