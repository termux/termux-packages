TERMUX_PKG_HOMEPAGE=https://github.com/phpredis/phpredis
TERMUX_PKG_DESCRIPTION="PHP extension for interfacing with Redis"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.3.0RC1"
TERMUX_PKG_SRCURL=https://github.com/phpredis/phpredis/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=86867bb5214f058cfb0e1abb07524d7f9bfd097ce06e23286993308b1b281082
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+'


termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
