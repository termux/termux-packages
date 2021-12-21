TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/FeatherPad
TERMUX_PKG_DESCRIPTION="Lightweight Qt Plain-Text Editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/tsujan/FeatherPad/releases/download/V${TERMUX_PKG_VERSION}/FeatherPad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bb605569f851527d4151c779b63bc06b6f974bbcc689cd2b80ef84e4f7fabafb
TERMUX_PKG_DEPENDS="hicolor-icon-theme, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras, hunspell"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

