TERMUX_PKG_HOMEPAGE=https://symas.com/lmdb/
TERMUX_PKG_DESCRIPTION="LMDB implements a simplified variant of the BerkeleyDB (BDB) API."
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_LICENSE_FILE="libraries/liblmdb/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.29
TERMUX_PKG_SRCURL=https://github.com/LMDB/lmdb/archive/LMDB_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22054926b426c66d8f2bc22071365df6e35f3aacf19ad943bc6167d4cae3bebb
TERMUX_PKG_EXTRA_MAKE_ARGS="-C libraries/liblmdb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DMDB_USE_ROBUST=0"
}
