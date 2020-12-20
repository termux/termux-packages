TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/icoutils/
TERMUX_PKG_DESCRIPTION="Extracts and converts images in MS Windows(R) icon and cursor files."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.32.3
TERMUX_PKG_SRCURL=https://savannah.nongnu.org/download/icoutils/icoutils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=17abe02d043a253b68b47e3af69c9fc755b895db68fdc8811786125df564c6e0
TERMUX_PKG_DEPENDS="libpng, perl"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
"
