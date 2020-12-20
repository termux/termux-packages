TERMUX_PKG_HOMEPAGE=https://getcomposer.org/
TERMUX_PKG_DESCRIPTION="Dependency Manager for PHP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=https://github.com/composer/composer.git
TERMUX_PKG_DEPENDS="php"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	composer install
	php -d phar.readonly=Off bin/compile
	install -Dm700 composer.phar $TERMUX_PREFIX/bin/composer
}
