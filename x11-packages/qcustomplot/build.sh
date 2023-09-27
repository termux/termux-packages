TERMUX_PKG_HOMEPAGE=https://www.qcustomplot.com/
TERMUX_PKG_DESCRIPTION="A Qt C++ widget for plotting and data visualization"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_SRCURL=(https://www.qcustomplot.com/release/${TERMUX_PKG_VERSION}/QCustomPlot-source.tar.gz
                   https://www.qcustomplot.com/release/${TERMUX_PKG_VERSION}/QCustomPlot-sharedlib.tar.gz)
TERMUX_PKG_SHA256=(5e2d22dec779db8f01f357cbdb25e54fbcf971adaee75eae8d7ad2444487182f
                   35d6ea9c7e8740edf0b37e2cb6aa6794150d0dde2541563e493f3f817012b4c0)
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
