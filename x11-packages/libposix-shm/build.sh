TERMUX_PKG_HOMEPAGE=https://github.com/xeffyr/termux-extra-packages
TERMUX_PKG_DESCRIPTION="A workaround for shm_open() and shm_unlink() for Android"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_REVISION=2

termux_step_make() {
	cp "${TERMUX_PKG_BUILDER_DIR}/posix-shm.c" ./
	cp "${TERMUX_PKG_BUILDER_DIR}/posix-shm.h" ./
	${CC} ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -I. -fPIC posix-shm.c -shared -o libposix-shm.so
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/include"
	mkdir -p "${TERMUX_PREFIX}/lib"
	cp -f posix-shm.h "${TERMUX_PREFIX}/include/"
	cp -f libposix-shm.so "${TERMUX_PREFIX}/lib/"
}
