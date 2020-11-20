# Skeleton build.sh script for new package.
# For reference about available fields, check the Termux Developer's Wiki page:
# https://github.com/termux/termux-packages/wiki/Creating-new-package

TERMUX_PKG_HOMEPAGE=http://eja.it
TERMUX_PKG_DESCRIPTION="eja micro web server"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=13.11.20
TERMUX_PKG_SRCURL=https://github.com/eja/eja/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d19a8071d524373bcfceb5dec834546e2c66108593f0bf54ef984d8a0819e050
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=$TERMUX_PREFIX prefix=/"
TERMUX_PKG_BUILD_IN_SRC=true
