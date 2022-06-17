TERMUX_PKG_HOMEPAGE=http://ngspice.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A mixed-level/mixed-signal circuit simulator"
TERMUX_PKG_LICENSE="BSD 3-Clause, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=37
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/ngspice/ngspice-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9beea6741a36a36a70f3152a36c82b728ee124c59a495312796376b30c8becbe
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-xspice --enable-cider --with-readline=yes --enable-openmp"
TERMUX_PKG_DEPENDS="libc++, readline, fftw"
TERMUX_PKG_GROUPS="science"

termux_step_post_make_install(){
  export NGSPICE_ICM_PATH="$TERMUX_PKG_BUILDDIR/src/xspice/icm"
  mkdir -p $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/analog/analog.cm $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/digital/digital.cm $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/spice2poly/spice2poly.cm $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/table/table.cm $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/xtradev/xtradev.cm $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/xtraevt/xtraevt.cm $TERMUX_PREFIX/lib/ngspice
  install -m755 $NGSPICE_ICM_PATH/analog/analog.cm $TERMUX_PREFIX/lib/ngspice
}
