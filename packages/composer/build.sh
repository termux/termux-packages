TERMUX_PKG_HOMEPAGE=https://getcomposer.org/
TERMUX_PKG_DESCRIPTION="Dependency Manager for PHP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@PuneetGopinath"
TERMUX_PKG_VERSION=2.2.18
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=git+https://github.com/composer/composer
TERMUX_PKG_DEPENDS="php"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	composer install
	php -d phar.readonly=Off bin/compile
	install -Dm700 composer.phar $TERMUX_PREFIX/bin/composer
}
