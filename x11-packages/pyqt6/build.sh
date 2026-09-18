TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/pyqt/
TERMUX_PKG_DESCRIPTION="Comprehensive Python Bindings for Qt v6"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/p/pyqt6/pyqt6-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45dd60aa69976de1918b5ced6b4e7b6a25abd2a919ecef5fd5826ecc76718889
TERMUX_PKG_DEPENDS="libc++, libglvnd-dev, python, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg, qt6-qttools, qt6-qtwebchannel, qt6-qtwebsockets, python-pip"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, sip, PyQt-builder"
TERMUX_PKG_PYTHON_TARGET_DEPS="PyQt6-sip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
--verbose
--scripts-dir=$TERMUX_PREFIX/bin
--confirm-license
--qmake=$TERMUX_PREFIX/lib/qt6/bin/host-qmake6
--no-designer-plugin
--no-qml-plugin
--disable=QtDesigner
--disable=QtOpenGL
--disable=QtOpenGLWidgets
--disable=QtQuick
--disable=QtQuickWidgets
--disable=QtQuick3D
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

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" --target-dir=$TERMUX_PYTHON_HOME/site-packages"
}

termux_step_make() {
	python ${TERMUX_PYTHON_CROSSENV_PREFIX}/build/bin/sip-build \
		--jobs ${TERMUX_PKG_MAKE_PROCESSES} \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install() {
	make -C build install

	local t="$TERMUX_PREFIX/bin/pyuic6"
	rm -f "${t}"
	sed -e 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
		"$TERMUX_PKG_BUILDER_DIR/pyuic6.in" > "${t}"
	chmod 0700 "${t}"
}
