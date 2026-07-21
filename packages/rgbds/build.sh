TERMUX_PKG_HOMEPAGE=https://rgbds.gbdev.io
TERMUX_PKG_DESCRIPTION="Rednex Game Boy Development System - An assembly toolchain for the Nintendo Game Boy & Game Boy Color"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.2+hotfix"
TERMUX_PKG_SRCURL=https://github.com/gbdev/rgbds/releases/download/v${TERMUX_PKG_VERSION}/rgbds-source.tar.gz
TERMUX_PKG_SHA256=c404afe6af549b923c2400ac7d5ebf30819a8192dea73bfd4c9b4ff80f3d446e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-support, libc++, libpng"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
