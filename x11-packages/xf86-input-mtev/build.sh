TERMUX_PKG_HOMEPAGE=http://x.org/
TERMUX_PKG_DESCRIPTION="X.org mtev driver"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://github.com/twaik/xorg-input-mtev/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=faecee79322b82c56b35422be3077f7c85a6d16d5ed8e3b3be809b7e765dd4ae
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CLANG=no
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
TERMUX_PKG_DEPENDS="libmtdev, xorg-server"

termux_step_make() {
	${CC} -o mtev_drv.so -shared -Wl,-soname -Wl,mtev_drv.so -lXFree86 `pkg-config --libs mtdev` -I$TERMUX_PREFIX/include/xorg -I$TERMUX_PREFIX/include/pixman-1 `pkg-config --cflags mtdev` ${CFLAGS} ${LDFLAGS} src/caps.c src/hw.c src/mtouch.c src/multitouch.c
}

termux_step_make_install() {
	install -d "$TERMUX_PREFIX/lib/xorg/modules/input"
	install -m 755 mtev_drv.so "$TERMUX_PREFIX/lib/xorg/modules/input/mtev_drv.so"
}
