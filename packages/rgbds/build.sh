TERMUX_PKG_HOMEPAGE=https://rgbds.gbdev.io
TERMUX_PKG_DESCRIPTION="Rednex Game Boy Development System - An assembly toolchain for the Nintendo Game Boy & Game Boy Color"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.3"
TERMUX_PKG_SRCURL=https://github.com/gbdev/rgbds/releases/download/v${TERMUX_PKG_VERSION}/rgbds-source.tar.gz
TERMUX_PKG_SHA256=97b523435f7da0b6d2a58daff447bb2c8280895c3f49eb4e63e5df8da63dd64d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-support, libc++, libpng"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
