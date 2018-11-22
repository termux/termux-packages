TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://github.com/twaik/xorg-input-mtev
TERMUX_PKG_DESCRIPTION="X.org mtev input driver"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://github.com/twaik/xorg-input-mtev/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=faecee79322b82c56b35422be3077f7c85a6d16d5ed8e3b3be809b7e765dd4ae
TERMUX_PKG_DEPENDS="mtdev, xorg-server"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    ${CC} \
        src/caps.c src/hw.c src/mtouch.c src/multitouch.c \
        $(pkg-config --cflags mtdev) \
        ${CFLAGS} \
        -I${TERMUX_PREFIX}/include/xorg \
        -I${TERMUX_PREFIX}/include/pixman-1 \
        -shared \
        -Wl,-soname -Wl,mtev_drv.so \
        ${LDFLAGS} \
        -lXFree86 \
        $(pkg-config --libs mtdev) \
        -o mtev_drv.so
}

termux_step_make_install() {
    install -Dm600 mtev_drv.so "${TERMUX_PREFIX}/lib/xorg/modules/input/mtev_drv.so"
}
