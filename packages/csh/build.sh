TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/csh
TERMUX_PKG_DESCRIPTION="C Shell with process control from 3BSD"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20220915
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/NetBSD/src/archive/84e62ad1d399f47b497daca008346b7d862cc129.tar.gz
TERMUX_PKG_SHA256=6f2b0655f3637c1e8811ab4b00e0c8fbb00b90a7b8c3948944a2300c59563c44
TERMUX_PKG_DEPENDS="libandroid-glob, libbsd, libedit"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp ${TERMUX_PKG_BUILDER_DIR}/LICENSE ./
}

termux_step_pre_configure() {
	cp usr.bin/printf/printf.c bin/csh/
}

termux_step_make() {
	make -C bin/csh
}

termux_step_make_install() {
	make -C bin/csh install
}

termux_step_post_make_install() {
	install -Dm600 -T bin/csh/csh.1 @TERMUX_PREFIX@/share/man/man1/csh.1
}
