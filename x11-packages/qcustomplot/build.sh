TERMUX_PKG_HOMEPAGE=https://www.qcustomplot.com/
TERMUX_PKG_DESCRIPTION="A Qt C++ widget for plotting and data visualization"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://www.qcustomplot.com/release/${TERMUX_PKG_VERSION}/QCustomPlot-source.tar.gz
                   https://www.qcustomplot.com/release/${TERMUX_PKG_VERSION}/QCustomPlot-sharedlib.tar.gz)
TERMUX_PKG_SHA256=(574cee47def3251d080168a23428859214277cb9b6876bcdb9ce9d00b2403fe4
                   cca0847dad29beff57b36e21efd1a0c40f74781f4648fb0921fb269d4f61d583)
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
CONFIG+=shared
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/qcustomplot-sharedlib/sharedlib-compilation"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}

termux_step_make_install() {
	local f
	for f in libqcustomplot.so*; do
		if test -L "${f}"; then
			ln -sf "$(readlink "${f}")" $TERMUX_PREFIX/lib/"${f}"
		else
			install -Dm600 -t $TERMUX_PREFIX/lib "${f}"
		fi
	done
	install -Dm600 -t $TERMUX_PREFIX/include ../../qcustomplot.h
}
