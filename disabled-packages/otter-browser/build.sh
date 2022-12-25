# x11-packages
TERMUX_PKG_HOMEPAGE=https://otter-browser.org
TERMUX_PKG_DESCRIPTION="Web browser with aspects of Opera (12.x)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.02
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL="https://github.com/OtterBrowser/otter-browser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d1e090a80fa736cd128f594184817078a08cac31614e85e7838ff1b64511d62d
TERMUX_PKG_DEPENDS="hunspell, libc++, qt5-qtbase, qt5-qtdeclarative, qt5-qtmultimedia, qt5-qtsvg, qt5-qtwebkit, qt5-qtxmlpatterns"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_QTWEBENGINE=OFF -DENABLE_QTWEBKIT=ON -DENABLE_CRASHREPORTS=OFF -DENABLE_SPELLCHECK=ON"

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo
		echo "********"
		echo "This package is planned to be REMOVED for security purposes."
		echo "See https://github.com/termux/termux-packages/issues/12813."
		echo
		echo "[TL;DR]"
		echo "Otter Browser in this package uses QtWebKit which is based on"
		echo "old and vulnerable WebKit and is not suitable for generic use."
		echo "********"
		echo
	EOF
}
