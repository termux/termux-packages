TERMUX_PKG_HOMEPAGE=https://github.com/phpredis/phpredis
TERMUX_PKG_DESCRIPTION="PHP extension for interfacing with Redis"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.2"
TERMUX_PKG_SRCURL=https://github.com/phpredis/phpredis/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=786944f1c7818cc7fd4289a0d0a42ea630a07ebfa6dfa9f70ba17323799fc430
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
