TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/desktop-file-utils
TERMUX_PKG_DESCRIPTION="Command line utilities for working with desktop entries"
TERMUX_PKG_VERSION=0.23
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6c094031bdec46c9f621708f919084e1cb5294e2c5b1e4c883b3e70cb8903385
TERMUX_PKG_DEPENDS="glib"

termux_step_create_debscripts() {
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
    cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./
    cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./
}
