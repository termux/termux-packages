TERMUX_PKG_HOMEPAGE=https://rgbds.gbdev.io
TERMUX_PKG_DESCRIPTION="Rednex Game Boy Development System - An assembly toolchain for the Nintendo Game Boy & Game Boy Color"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://github.com/gbdev/rgbds/releases/download/v${TERMUX_PKG_VERSION}/rgbds-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cc9340534f24b6b1ce8a6d8c4d4d92b2ef6c5dcf1c3e3709ea362626a3435a96
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-support, libc++, libpng"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
