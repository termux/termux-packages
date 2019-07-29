TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org font utilities"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/font/font-util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=aa7ebdb0715106dd255082f2310dbaa2cd7e225957c2a77d719720c7cc92b921

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-mapdir=${TERMUX_PREFIX}/share/fonts/util
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
"
