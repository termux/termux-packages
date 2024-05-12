TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Tab Window Manager for the X Window System"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.12
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/twm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aaf201d4de04c1bb11eed93de4bee0147217b7bdf61b7b761a56b2fdc276afe4
TERMUX_PKG_DEPENDS="libice, libsm, libx11, libxext, libxmu, libxrandr, libxt"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
