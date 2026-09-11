TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/pyqtwebengine/
TERMUX_PKG_DESCRIPTION="Python Bindings for the Qt6 WebEngine Framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/p/pyqt6-webengine/pyqt6_webengine-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=15cf49efbbbd4c6bc87653b2c4ae80d6049f800e31620b336734ae2e37cbedae
TERMUX_PKG_DEPENDS="libc++, pyqt6, python, python-pip, qt6-qtbase, qt6-qtwebchannel, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
# Qt6-Webengine doesn't support i686 on Termux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, PyQt-builder"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
--verbose
--scripts-dir=$TERMUX_PREFIX/bin
--qmake=$TERMUX_PREFIX/lib/qt6/bin/host-qmake6
--disable=QtWebEngineQuick
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
	ln -sf ${_cxx} ${_bindir}/clang++
	ln -sf ${_cxx} ${_bindir}/g++
	ln -sf ${_cxx} ${_bindir}/c++
	ln -sf ${_cxx} ${_bindir}/clang
	ln -sf ${_cxx} ${_bindir}/gcc
	export PATH=${_bindir}:$PATH

	mkdir -p ${TERMUX_PYTHON_CROSSENV_PREFIX}/build/lib/python${TERMUX_PYTHON_VERSION}/site-packages/PyQt6
	ln -sf $TERMUX_PREFIX/lib/python${TERMUX_PYTHON_VERSION}/site-packages/PyQt6/bindings \
		${TERMUX_PYTHON_CROSSENV_PREFIX}/build/lib/python${TERMUX_PYTHON_VERSION}/site-packages/PyQt6/bindings

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" --target-dir=$TERMUX_PYTHON_HOME/site-packages"
}

termux_step_make() {
	python ${TERMUX_PYTHON_CROSSENV_PREFIX}/build/bin/sip-build \
		--jobs ${TERMUX_PKG_MAKE_PROCESSES} \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install() {
	make -C build install
}
