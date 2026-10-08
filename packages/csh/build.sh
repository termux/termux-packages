TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/csh
TERMUX_PKG_DESCRIPTION="C Shell with process control from 3BSD"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20240808
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/c/csh/csh_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=df916baa73c264516177c6667cc0a061f6eb9743f862b625f17067d74a3f4d1c
TERMUX_PKG_DEPENDS="libandroid-glob, libbsd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(curl -fsSL https://deb.debian.org/debian/pool/main/c/csh/ |
		sed -nE 's/.*csh_([0-9]+)\.orig\.tar\.xz.*/\1/p' | sort -Vr | head -n1)"
	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE ./
}

termux_step_pre_configure() {
	CFLAGS="${CFLAGS/-Oz/-Os}"
	LDFLAGS+=" -Wl,-z,muldefs"
}

termux_step_post_configure() {
	make const.h
}

termux_step_post_make_install() {
	install -Dm600 -T ./csh.1 ${TERMUX_PREFIX}/share/man/man1/csh.1
}
