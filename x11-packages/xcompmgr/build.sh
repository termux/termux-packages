TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Composite Window-effects manager for X.org"
TERMUX_PKG_VERSION=1.1.7
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xcompmgr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c8049b1a2531313be7469ba9b198d334f0b91cc01efc2b20b9afcb117e4d6892
TERMUX_PKG_DEPENDS="libx11, libxcomposite, libxdamage, libxext, libxfixes, libxrender"
