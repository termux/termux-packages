TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Set the keyboard using the X Keyboard Extension"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/setxkbmap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b560c678da6930a0da267304fa3a41cc5df39a96a5e23d06f14984c87b6f587b
TERMUX_PKG_DEPENDS="libx11, libxkbfile, libxrandr"
