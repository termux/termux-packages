TERMUX_PKG_HOMEPAGE=https://github.com/thangnhox/ip4termux
TERMUX_PKG_DESCRIPTION="Simple IP tool for android 13+"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@thangnhox"
TERMUX_PKG_VERSION=1.1

TERMUX_PKG_SRCURL=https://github.com/thangnhox/ip4termux/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6945172838a414972e43378740519e31c0306b156f386291e9790cb25cb54418

termux_step_make() {
    cd $TERMUX_PKG_SRCDIR
    $CC $CFLAGS $CPPFLAGS $LDFLAGS ip.c -o ip
}

termux_step_make_install() {
    install -Dm755 $TERMUX_PKG_SRCDIR/ip $TERMUX_PREFIX/bin/ip4termux
}
