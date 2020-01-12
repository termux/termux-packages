TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/rdiff-backup/
TERMUX_PKG_DESCRIPTION="A utility for local/remote mirroring and incremental backups"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ee030ce638df0eb1047cf72578e0de15d9a3ee9ab24da2dc0023e2978be30c06
TERMUX_PKG_DEPENDS="librsync, python2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	local _PYTHON_VERSION=2.7
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}"
	export LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export LDSHARED="$CC -shared"
	python${_PYTHON_VERSION} setup.py install --prefix=$TERMUX_PREFIX --force
}
