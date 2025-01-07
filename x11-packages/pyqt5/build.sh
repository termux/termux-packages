TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/pyqt/
TERMUX_PKG_DESCRIPTION="Comprehensive Python Bindings for Qt v5"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.15.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/P/PyQt5/PyQt5-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fda45743ebb4a27b4b1a51c6d8ef455c4c1b5d610c90d2934c7802b5c1557c52
TERMUX_PKG_DEPENDS="libc++, python, qt5-qtbase, qt5-qtdeclarative, qt5-qtlocation, qt5-qtmultimedia, qt5-qtsensors, qt5-qtsvg, qt5-qttools, qt5-qtwebchannel, qt5-qtwebsockets, qt5-qtx11extras, qt5-qtxmlpatterns, python-pip"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, 'sip>=6.6.2,<7', 'PyQt-builder>=1.14.1,<2'"
TERMUX_PKG_PYTHON_TARGET_DEPS="'PyQt5-sip>=12.13,<13'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
--verbose
--scripts-dir=$TERMUX_PREFIX/bin
--confirm-license
--qmake=$TERMUX_PREFIX/opt/qt/cross/bin/qmake
"

# ```
# /home/builder/.termux-build/pyqt5/src/sip/QtQuick/qsggeometry.sip:136:30:
# error: use of undeclared identifier 'GL_BYTE'
#			 case GL_BYTE:
#			      ^
# /home/builder/.termux-build/pyqt5/src/sip/QtQuick/qsggeometry.sip:148:30:
# error: use of undeclared identifier 'GL_FLOAT'
#			 case GL_FLOAT:
#			      ^
# /home/builder/.termux-build/pyqt5/src/sip/QtQuick/qsggeometry.sip:152:30:
# error: use of undeclared identifier 'GL_INT'
#			 case GL_INT:
#			      ^
# 3 errors generated.
# ```
TERMUX_PKG_EXTRA_MAKE_ARGS+=" --disable=QtQuick"

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
		--jobs ${TERMUX_PKG_MAKE_PROCESSES} \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install() {
	make -C build install

	local f
	for f in pylupdate5 pyrcc5 pyuic5; do
		local t="$TERMUX_PREFIX/bin/${f}"
		rm -f "${t}"
		sed -e 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
			"$TERMUX_PKG_BUILDER_DIR/${f}.in" > "${t}"
		chmod 0700 "${t}"
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install $TERMUX_PKG_PYTHON_TARGET_DEPS
	EOF
}
