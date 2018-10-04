TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Scientific calculator for X"
TERMUX_PKG_VERSION=1.0.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/xcalc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2f73c7160c09dc32586ea07daa408ac897c0a16eaa98cad9f9e4ee98cd9057d8
TERMUX_PKG_DEPENDS="libx11, libxaw, libxt, xorg-fonts-75dpi | xorg-fonts-100dpi"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
