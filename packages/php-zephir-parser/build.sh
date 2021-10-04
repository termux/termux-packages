TERMUX_PKG_HOMEPAGE=https://github.com/phalcon/php-zephir-parser
TERMUX_PKG_DESCRIPTION="The Zephir Parser delivered as a C extension for the PHP language."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://github.com/zephir-lang/php-zephir-parser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8e6a5356e27e82ff9fa070d1b717a866188165a64dd02dee4494e7baff3739e4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=php
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
# php is (currently) blacklisted for x86_64. Need to blacklist
# php-zephir-parser well for the same arch for
#   ./build-package.sh -a all -i php-zephir-parser
# to succeed
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_pre_configure() {
	# copy host build `lemon`
	cp "$TERMUX_PKG_HOSTBUILD_DIR/lemon" $TERMUX_PKG_SRCDIR/parser/
	$TERMUX_PREFIX/bin/phpize
}

termux_step_host_build() {
	# lemon excuted by build host, so we need build it by hostbuild, then it will be reused by later build
	gcc -o "$TERMUX_PKG_HOSTBUILD_DIR/lemon" $TERMUX_PKG_SRCDIR/parser/lemon.c

}
