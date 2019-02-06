TERMUX_PKG_HOMEPAGE=https://lxde.org/
TERMUX_PKG_DESCRIPTION="Extremely fast and lightweight file manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcmanfm/pcmanfm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6804043b3ee3a703edde41c724946174b505fe958703eadbd7e0876ece836855
TERMUX_PKG_DEPENDS="libfm, lxmenu-data"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-gtk=3
"
