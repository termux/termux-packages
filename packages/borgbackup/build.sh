TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="1.4.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=79bbfa745d1901d685973584bd2d16a350686ddd176f6a2244490fb01996441f
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, python-pip, xxhash, zstd"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, Cython, pkgconfig, setuptools, setuptools-scm, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="'msgpack==1.0.8', packaging"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="borgbackup-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}
