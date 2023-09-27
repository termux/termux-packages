TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Composite Window-effects manager for X.org"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.9
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xcompmgr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4875b6698672d01eb3a5080bde6eac9a989d486a82226a2d5e23624f1527a6f0
TERMUX_PKG_DEPENDS="libx11, libxcomposite, libxdamage, libxext, libxfixes, libxrender"
