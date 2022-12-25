TERMUX_PKG_HOMEPAGE=http://tarot.freeshell.org/leafpad/
TERMUX_PKG_DESCRIPTION="GTK+ based simple text editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.19
TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/leafpad/leafpad-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=07d3f712f4dbd0a33251fd1dee14e21afdc9f92090fc768c11ab0ac556adbe97
TERMUX_PKG_DEPENDS="glib, gtk2, libcairo, pango"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/locale
share/icons/hicolor/icon-theme.cache
"
