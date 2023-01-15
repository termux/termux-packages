TERMUX_PKG_HOMEPAGE=https://github.com/notaz/pcsx_rearmed
TERMUX_PKG_DESCRIPTION="Yet another PCSX fork based on the PCSX-Reloaded project"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=23
TERMUX_PKG_SRCURL=git+https://github.com/notaz/pcsx_rearmed
TERMUX_PKG_GIT_BRANCH=r${TERMUX_PKG_VERSION}
TERMUX_PKG_SHA256=887e9b5ee7b8115d35099c730372b4158fd3e215955a06d68e20928b339646af
TERMUX_PKG_DEPENDS="libpng, mesa, pulseaudio, sdl, zlib"
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_PKG_BUILD_DEPENDS="mesa-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -I$TERMUX_PREFIX/include"
}

termux_step_configure() {
	sh ./configure
}

termux_step_make_install() {
	install -Dm755 pcsx ${PREFIX}/bin/pcsx
	mkdir -p ${PREFIX}/etc/pcsx
	cp -r frontend/pandora/skin ${PREFIX}/etc/pcsx/
}
