TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/csh
TERMUX_PKG_DESCRIPTION="C Shell with process control from 3BSD"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20110502
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://deb.debian.org/debian/pool/main/c/csh/csh_${TERMUX_PKG_VERSION}.orig.tar.gz"
TERMUX_PKG_SHA256=8bcba4fe796df1b9992e2d94e07ce6180abb24b55488384f9954aa61ecd8d68b
TERMUX_PKG_DEPENDS="libandroid-glob, libbsd"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp "${TERMUX_PKG_BUILDER_DIR}/LICENSE" "${TERMUX_PKG_SRCDIR}"
}

termux_step_pre_configure() {
	CFLAGS="${CFLAGS/-Oz/-Os} -I$TERMUX_PREFIX/include"
	LDFLAGS+=" -landroid-glob -lbsd"
}

termux_step_post_configure() {
	make const.h
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" csh
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1/" csh.1
}
