TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 keyboard file manipulation library"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libxkbfile-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8623dc26e7aac3c5ad8a25e57b566f4324f5619e5db38457f0804ee4ed953443
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
