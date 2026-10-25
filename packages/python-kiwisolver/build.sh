TERMUX_PKG_HOMEPAGE=https://github.com/nucleic/kiwi
TERMUX_PKG_DESCRIPTION="An efficient C++ implementation of the Cassowary constraint solving algorithm"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/k/kiwisolver/kiwisolver-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f1303ef2eec81262a4b708c3e858afe58d7c75ad91c1c05266eda7673369859a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, cppy, setuptools, setuptools_scm, wheel"

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="kiwisolver-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-android_${TERMUX_ARCH}.whl"
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}
