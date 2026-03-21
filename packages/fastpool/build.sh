TERMUX_PKG_HOMEPAGE=https://example.com
TERMUX_PKG_DESCRIPTION="Fast memory pool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0

termux_step_make() {
    $CC $CFLAGS -c fastpool.c -o fastpool.o
    $AR rcs libfastpool.a fastpool.o
}
