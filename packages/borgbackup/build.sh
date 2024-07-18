TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c54c45155643fa66fed7f9ff2d134ea0a58d0ac197c18781ddc2fb236bf6ed29
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, xxhash, zstd"
# FIXME: Force use setuptools 65. This should be no more needed after PR 18078
# FIXME: is merged or builder image bumps to Ubuntu 24.
TERMUX_PKG_PYTHON_COMMON_DEPS="build, Cython, pkgconfig, 'setuptools==65.7.0', setuptools-scm, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="'msgpack==1.0.8', packaging"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x --config-setting builddir="$TERMUX_PKG_BUILDDIR" "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="borgbackup-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/dist/${_wheel}"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install $TERMUX_PKG_PYTHON_TARGET_DEPS
	EOF
}
