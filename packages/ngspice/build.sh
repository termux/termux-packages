TERMUX_PKG_HOMEPAGE=http://ngspice.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A mixed-level/mixed-signal circuit simulator"
TERMUX_PKG_LICENSE="BSD 3-Clause, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=37
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/ngspice/ngspice-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9beea6741a36a36a70f3152a36c82b728ee124c59a495312796376b30c8becbe
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--build=x86_64-linux-gnu
--host=$TERMUX_HOST_PLATFORM
--enable-xspice
--enable-cider
--with-readline=yes
--enable-openmp
"
TERMUX_PKG_DEPENDS="libc++, readline, fftw"
TERMUX_PKG_GROUPS="science"
