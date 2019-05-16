TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Create an index of scalable font files for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.7
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/mkfontdir-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=56d52a482df130484e51fd066d1b6eda7c2c02ddbc91fe6e2be1b9c4e7306530
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="coreutils, dash, findutils, xorg-mkfontscale"

termux_step_create_debscripts() {
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./
	cp -f "${TERMUX_PKG_BUILDER_DIR}/triggers" ./
}
