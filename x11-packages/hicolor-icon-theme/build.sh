TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/icon-theme/
TERMUX_PKG_DESCRIPTION="Freedesktop.org Hicolor icon theme"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.17
TERMUX_PKG_REVISION=27
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm644 "${TERMUX_PKG_BUILDER_DIR}/index.theme" "${TERMUX_PREFIX}/share/icons/hicolor/index.theme"
}
