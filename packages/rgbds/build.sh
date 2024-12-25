TERMUX_PKG_HOMEPAGE=https://rgbds.gbdev.io
TERMUX_PKG_DESCRIPTION="Rednex Game Boy Development System - An assembly toolchain for the Nintendo Game Boy & Game Boy Color"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL=https://github.com/gbdev/rgbds/releases/download/v${TERMUX_PKG_VERSION}/rgbds-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e15721fe11a943a9fc6d11958abe1951d65fd285ade5af75c968d1bd1774caf6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-support, libc++, libpng"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
