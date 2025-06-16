TERMUX_PKG_HOMEPAGE=https://github.com/msgpack/msgpack-python
TERMUX_PKG_DESCRIPTION="MessagePack serializer implementation for Python"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.1"
# _cmsgpack.c is absent in https://github.com/msgpack/msgpack-python/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://pypi.org/packages/source/m/msgpack/msgpack-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77b79ce34a2bdab2594f490c8e80dd62a02d650b91a75159a63ec413b8d104cd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="build, Cython, setuptools, wheel"

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="msgpack-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}
