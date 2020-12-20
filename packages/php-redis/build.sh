TERMUX_PKG_HOMEPAGE=https://github.com/phpredis/phpredis
TERMUX_PKG_DESCRIPTION="PHP extension for interfacing with Redis"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.1
TERMUX_PKG_SRCURL=https://github.com/phpredis/phpredis/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=930dc88ef126509b8991c52757fdc68908c753b476ad6f25dae0ce6925870f14
TERMUX_PKG_DEPENDS=php

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
