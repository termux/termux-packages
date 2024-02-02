TERMUX_PKG_HOMEPAGE=https://symas.com/lmdb/
TERMUX_PKG_DESCRIPTION="LMDB implements a simplified variant of the BerkeleyDB (BDB) API"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_LICENSE_FILE="libraries/liblmdb/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.32"
TERMUX_PKG_SRCURL=https://git.openldap.org/openldap/openldap/-/archive/LMDB_${TERMUX_PKG_VERSION}/openldap-LMDB_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=70d553f80968f5117f2f3d4d7f0b89cb8fb69dadc35131263a2499bb58f7d015
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C libraries/liblmdb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DMDB_USE_ROBUST=0"
}
