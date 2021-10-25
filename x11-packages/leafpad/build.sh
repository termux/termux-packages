TERMUX_PKG_HOMEPAGE=http://tarot.freeshell.org/leafpad/
TERMUX_PKG_DESCRIPTION="GTK+ based simple text editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.8.18.1
TERMUX_PKG_REVISION=15
TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/leafpad/leafpad-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=959d22ae07f22803bc66ff40d373a854532a6e4732680bf8a96a3fbcb9f80a2c
TERMUX_PKG_DEPENDS="gtk2"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/locale
share/icons/hicolor/icon-theme.cache
"
