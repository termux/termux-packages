TERMUX_PKG_HOMEPAGE=https://saitoha.github.io/libsixel/
TERMUX_PKG_DESCRIPTION="Encoder/decoder implementation for DEC SIXEL graphics"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libsixel/libsixel/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=028552eb8f2a37c6effda88ee5e8f6d87b5d9601182ddec784a9728865f821e0
TERMUX_PKG_DEPENDS="libcurl, libjpeg-turbo, libpng, libgd, gdk-pixbuf"
TERMUX_PKG_BREAKS="libsixel-dev"
TERMUX_PKG_REPLACES="libsixel-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgdk-pixbuf2=enabled
-Dgd=enabled
-Dlibcurl=enabled
-Dpython2=disabled
"
