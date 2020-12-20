TERMUX_PKG_HOMEPAGE=https://symas.com/lmdb/
TERMUX_PKG_DESCRIPTION="LMDB implements a simplified variant of the BerkeleyDB (BDB) API."
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.24
TERMUX_PKG_SRCURL=https://github.com/LMDB/lmdb/archive/LMDB_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=44602436c52c29d4f301f55f6fd8115f945469b868348e3cddaf91ab2473ea26
TERMUX_PKG_EXTRA_MAKE_ARGS="-C $TERMUX_PKG_SRCDIR/libraries/liblmdb"

termux_step_pre_configure() {
	CPPFLAGS+=" -DMDB_USE_ROBUST=0"
}

termux_step_install_license() {
	install -Dm600 "$TERMUX_PKG_SRCDIR/libraries/liblmdb/LICENSE" \
		"$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE"
}
