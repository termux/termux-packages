TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/qscintilla/
TERMUX_PKG_DESCRIPTION="Python bindings for QScintilla"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `qscintilla` package.
TERMUX_PKG_VERSION=2.14.1
TERMUX_PKG_SRCURL=https://www.riverbankcomputing.com/static/Downloads/QScintilla/${TERMUX_PKG_VERSION}/QScintilla_src-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d
TERMUX_PKG_DEPENDS="libc++, pyqt5, python, qscintilla (>= ${TERMUX_PKG_VERSION}), qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, PyQt-builder"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
--verbose
--scripts-dir=$TERMUX_PREFIX/bin
--qmake=$TERMUX_PREFIX/opt/qt/cross/bin/qmake
--target-dir=$TERMUX_PYTHON_HOME/site-packages
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/Python"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
	cd "$TERMUX_PKG_SRCDIR"

	ln -sf pyproject{-qt5,}.toml

	local h="$TERMUX_PREFIX/include/Qsci/qsciglobal.h"
	local _CFGTEST_QSCI
	_CFGTEST_QSCI=$(( $(sed -En 's/^#define\s+QSCINTILLA_VERSION\s+([^\s]+).*/\1/p' "${h}") ))
	_CFGTEST_QSCI+=" "
	_CFGTEST_QSCI+=$(sed -En 's/^#define\s+QSCINTILLA_VERSION_STR\s+"([^"]+)".*/\1/p' "${h}")

	local _cxx=$(basename $CXX)
	local _bindir=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p ${_bindir}
	sed -e 's|@CXX@|'"$(command -v $CXX)"'|g' \
		-e 's|@CFGTEST_QSCI@|'"${_CFGTEST_QSCI}"'|g' \
		-e 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
		-e 's|@PYTHON_VERSION@|'"${TERMUX_PYTHON_VERSION}"'|g' \
		$TERMUX_PKG_BUILDER_DIR/cxx-wrapper > ${_bindir}/${_cxx}
	chmod 0700 ${_bindir}/${_cxx}
	export PATH=${_bindir}:$PATH
}

termux_step_make() {
	python ${TERMUX_PYTHON_CROSSENV_PREFIX}/build/bin/sip-build \
		--jobs ${TERMUX_PKG_MAKE_PROCESSES} \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install() {
	make -C build install
}
