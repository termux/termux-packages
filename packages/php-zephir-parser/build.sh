# Contributor: @ian4hu
TERMUX_PKG_HOMEPAGE=https://github.com/phalcon/php-zephir-parser
TERMUX_PKG_DESCRIPTION="The Zephir Parser delivered as a C extension for the PHP language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL=https://github.com/zephir-lang/php-zephir-parser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dbf81ee7d4477290aec64ac7252e0f5635e51044b6a869216b90c98db1c98c96
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_pre_configure() {
	# copy host build `lemon`
	cp "$TERMUX_PKG_HOSTBUILD_DIR/lemon" $TERMUX_PKG_SRCDIR/parser/
	$TERMUX_PREFIX/bin/phpize
}

termux_step_host_build() {
	# lemon excuted by build host, so we need build it by hostbuild, then it will be reused by later build
	gcc -std=c17 -o "$TERMUX_PKG_HOSTBUILD_DIR/lemon" $TERMUX_PKG_SRCDIR/parser/lemon.c

}
