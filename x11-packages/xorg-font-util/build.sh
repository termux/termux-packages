TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org font utilities"
# Licenses: MIT, BSD 2-Clause, UCD
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/font/font-util-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c9f64123c194b150fee89049991687386e6ff36ef2af7b80ba53efaf368cc95
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-mapdir=${TERMUX_PREFIX}/share/fonts/util
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
"
