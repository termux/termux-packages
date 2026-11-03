TERMUX_PKG_HOMEPAGE=https://github.com/rapidfuzz/Levenshtein
TERMUX_PKG_DESCRIPTION="Fast computation of Levenshtein distance"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=0.27.5
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/81/ab/d55fdebfdee7605df174913708d44f75dfec0ec5e4e5fd8e978bb88897eb/levenshtein-0.27.5.tar.gz
TERMUX_PKG_SHA256=22021caf5867a46fae5ab927bbdcb430599d7e5ee3898449cbbe430ff07b7d08
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python, python-pip, python-rapidfuzz"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, build, scikit-build-core, 'Cython>=3.1.6,<3.3.0'"

termux_step_make() {
	if [ -x "$TERMUX_PYTHON_CROSSENV_PREFIX/cross/bin/python$TERMUX_PYTHON_VERSION" ]; then
		export SKBUILD_CMAKE_DEFINE="Python_EXECUTABLE=$TERMUX_PYTHON_CROSSENV_PREFIX/build/bin/python$TERMUX_PYTHON_VERSION;Python_INCLUDE_DIR=$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION;Python_LIBRARY=$TERMUX_PREFIX/lib/libpython$TERMUX_PYTHON_VERSION.so"
	fi
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"/dist/levenshtein-*.whl
}
