TERMUX_PKG_HOMEPAGE=https://rgbds.gbdev.io
TERMUX_PKG_DESCRIPTION="Rednex Game Boy Development System - An assembly toolchain for the Nintendo Game Boy & Game Boy Color"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://github.com/gbdev/rgbds/releases/download/v${TERMUX_PKG_VERSION}/rgbds-source.tar.gz
TERMUX_PKG_SHA256=5f1b5531f8b7033b5ac3e7d1b0ed2a61cf5c2784e4801d7f4839cc8bde7fa1f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-support, libc++, libpng"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
