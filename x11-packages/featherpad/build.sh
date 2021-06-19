TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/FeatherPad
TERMUX_PKG_DESCRIPTION="Lightweight Qt Plain-Text Editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/tsujan/FeatherPad/releases/download/V${TERMUX_PKG_VERSION}/FeatherPad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f95c5494451890eefa7177022b065648b0633d5096715ae7f47c2cc7d784aec8
TERMUX_PKG_DEPENDS="hicolor-icon-theme, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras, hunspell"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

