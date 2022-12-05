TERMUX_PKG_HOMEPAGE="https://xorg.freedesktop.org/"
TERMUX_PKG_DESCRIPTION="Primitive command line interface to RandR extension"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xrandr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c8bee4790d9058bacc4b6246456c58021db58a87ddda1a9d0139bf5f18f1f240
TERMUX_PKG_DEPENDS="libx11, libxrandr"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xorgproto"
