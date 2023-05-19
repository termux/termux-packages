TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Set the keyboard using the X Keyboard Extension"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/setxkbmap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=be8d8554d40e981d1b93b5ff82497c9ad2259f59f675b38f1b5e84624c07fade
TERMUX_PKG_DEPENDS="libx11, libxkbfile, libxrandr"
