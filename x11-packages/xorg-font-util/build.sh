TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org font utilities"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=19
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/font/font-util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3ad880444123ac06a7238546fa38a2a6ad7f7e0cc3614de7e103863616522282

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-mapdir=${TERMUX_PREFIX}/share/fonts/util
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
"
