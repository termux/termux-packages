TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Server access control program for X"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.9
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/xhost-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=ea86b531462035b19a2e5e01ef3d9a35cca7d984086645e2fc844d8f0e346645
TERMUX_PKG_DEPENDS="libx11, libxmu"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
