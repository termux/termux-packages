TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X clock"
TERMUX_PKG_VERSION=1.0.7
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xclock-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=23ceeca94e3e20a6c26a703ac7f789066d4517f8d2cb717ae7cb28a617d97dd0
TERMUX_PKG_DEPENDS="libandroid-support, libx11, libxaw, libxft, libxkbfile, libxmu, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_CONFLICTS="xclock"
TERMUX_PKG_REPLACES="xclock"
