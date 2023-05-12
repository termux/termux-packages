TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Athena Widget library"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.15
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXaw-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ab35f70fde9fb02cc71b342f654846a74328b74cb3a0703c02d20eddb212754a
TERMUX_PKG_DEPENDS="libx11, libxext, libxmu, libxpm, libxt"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
