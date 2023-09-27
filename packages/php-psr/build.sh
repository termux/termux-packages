TERMUX_PKG_HOMEPAGE=https://github.com/jbboehr/php-psr
TERMUX_PKG_DESCRIPTION="PHP extension providing the accepted PSR interfaces"
TERMUX_PKG_LICENSE="BSD Simplified"
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jbboehr/php-psr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa4071bedf625b3f434b4dbcc005913d291790039d03ae429bfea252f9ab2b54
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize
}
