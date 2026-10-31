TERMUX_PKG_HOMEPAGE=https://github.com/rapidfuzz/RapidFuzz
TERMUX_PKG_DESCRIPTION="Rapid fuzzy string matching"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=3.14.6
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/18/97/226c43b7b5d957bc3840ed52ea99eed261f99834c4619be7a4742cbaeafa/rapidfuzz-3.14.6.tar.gz
TERMUX_PKG_SHA256=e13a8160d017b499ec7a2fa9d0ce1ae2e7377080815785819f966fb235d4eb60
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, build, scikit-build-core, 'Cython>=3.1.6,<3.3.0'"

termux_step_make() {
	# Explicit FindPython hints: no reliance on the crossenv cross
	# interpreter (broken on 32-bit). Same files aarch64 resolves.
	if [ -x "$TERMUX_PYTHON_CROSSENV_PREFIX/build/bin/python$TERMUX_PYTHON_VERSION" ]; then
		export SKBUILD_CMAKE_DEFINE="Python_EXECUTABLE=$TERMUX_PYTHON_CROSSENV_PREFIX/build/bin/python$TERMUX_PYTHON_VERSION;Python_INCLUDE_DIR=$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION;Python_LIBRARY=$TERMUX_PREFIX/lib/libpython$TERMUX_PYTHON_VERSION.so"
	fi
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"/dist/rapidfuzz-*.whl
}
