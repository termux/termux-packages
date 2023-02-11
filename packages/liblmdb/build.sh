TERMUX_PKG_HOMEPAGE=https://symas.com/lmdb/
TERMUX_PKG_DESCRIPTION="LMDB implements a simplified variant of the BerkeleyDB (BDB) API"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_LICENSE_FILE="libraries/liblmdb/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.30
TERMUX_PKG_SRCURL=https://git.openldap.org/openldap/openldap/-/archive/LMDB_${TERMUX_PKG_VERSION}/openldap-LMDB_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8c5a93ac3cc97427c54571ad5a6140b7469389d01e6d2f43df39f96d3a4ccef7
TERMUX_PKG_EXTRA_MAKE_ARGS="-C libraries/liblmdb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DMDB_USE_ROBUST=0"
}
