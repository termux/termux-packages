TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X Keyboard description compiler"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xkbcomp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fa50d611ef41e034487af7bd8d8c718df53dd18002f591cca16b0384afc58e98
TERMUX_PKG_DEPENDS="libx11, libxkbfile"
