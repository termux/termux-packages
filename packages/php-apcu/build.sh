TERMUX_PKG_HOMEPAGE=http://php.net/apcu
TERMUX_PKG_DESCRIPTION="APCu - APC User Cache"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION=5.1.21
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/krakjoe/apcu/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_SHA256=6406376c069fd8e51cd470bbb38d809dee7affbea07949b2a973c62ec70bd502
TERMUX_PKG_AUTO_UPDATE=true
# php is (currently) blacklisted for x86_64. Need to blacklist
# php-apcu as well for the same arch for
#   ./build-package.sh -a all -i php-apcu
# to succeed
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
