TERMUX_PKG_HOMEPAGE=https://mate-desktop.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-desktop contains the libmate-desktop library, the mate-about program as well as some desktop-wide documents."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-desktop/releases/download/v$TERMUX_PKG_VERSION/mate-desktop-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5f7c6b9b88886cb3393b3ffd57f9e9ec29f03a3c23ce8d4b45292de0aa4652a3
TERMUX_PKG_DEPENDS="libmatekbd, dconf"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"
