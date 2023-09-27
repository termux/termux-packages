TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/pyqtwebengine/
TERMUX_PKG_DESCRIPTION="Python Bindings for the Qt WebEngine Framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.15.6
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/P/PyQtWebEngine/PyQtWebEngine-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ae241ef2a61c782939c58b52c2aea53ad99b30f3934c8358d5e0a6ebb3fd0721
TERMUX_PKG_DEPENDS="libc++, pyqt5, python, qt5-qtbase, qt5-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, PyQt-builder"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
--verbose
--scripts-dir=$TERMUX_PREFIX/bin
--qmake=$TERMUX_PREFIX/opt/qt/cross/bin/qmake
"

termux_step_pre_configure() {
	local _cxx=$(basename $CXX)
	local _bindir=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p ${_bindir}
	sed -e 's|@CXX@|'"$(command -v $CXX)"'|g' \
		-e 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
		-e 's|@PYTHON_VERSION@|'"${TERMUX_PYTHON_VERSION}"'|g' \
		$TERMUX_PKG_BUILDER_DIR/cxx-wrapper > ${_bindir}/${_cxx}
	chmod 0700 ${_bindir}/${_cxx}
	export PATH=${_bindir}:$PATH

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" --target-dir=$TERMUX_PYTHON_HOME/site-packages"
}

termux_step_make() {
	python ${TERMUX_PYTHON_CROSSENV_PREFIX}/build/bin/sip-build \
		--jobs ${TERMUX_MAKE_PROCESSES} \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install() {
	make -C build install
}
