TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="1.4.5"
TERMUX_PKG_SRCURL="https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4f9a5fe584c504b15485841236750dea16aa7cd2ddbc4a594e9d2ce5c49c4508
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, python-pip, xxhash, zstd"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, Cython, pkgconfig, setuptools, setuptools-scm, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="'msgpack==1.0.8', packaging"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
