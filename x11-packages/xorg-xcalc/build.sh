TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Scientific calculator for X"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/xcalc-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8578dfa1457e94289f6d6ed6146714307d8a73a1b54d2f42af1321b625fc1cd4
TERMUX_PKG_DEPENDS="libx11, libxaw, libxt, xorg-fonts-75dpi | xorg-fonts-100dpi"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
