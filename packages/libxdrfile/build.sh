TERMUX_PKG_HOMEPAGE="https://userguide.mdanalysis.org/stable/formats/reference/xtc.html"
TERMUX_PKG_DESCRIPTION="Library for reading and writing xtc, edr and trr files"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.4"
TERMUX_PKG_SRCURL="ftp://ftp.gromacs.org/pub/contrib/xdrfile-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e3c587c5ff24441a092fe2f3bc1dc03667bf126558f437161e779bfbcce48022

# enable fortran when we have gfortran
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-pic
--enable-shared
--disable-static
--disable-fortran
"
