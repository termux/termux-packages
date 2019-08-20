TERMUX_PKG_HOMEPAGE=http://seafile.com
TERMUX_PKG_DESCRIPTION="Seafile is a file syncing and sharing software with file encryption and group sharing"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=7.0.2
TERMUX_PKG_SRCURL=https://github.com/haiwen/seafile/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b6041d96fd04a6ef05f7cacbaffcbdde96a63b8ec4f824d7dbd741eae83d9389
TERMUX_PKG_DEPENDS="ccnet, libcurl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_configure() {
	# the package has trouble to prepare some headers
	cd $TERMUX_PKG_SRCDIR/lib
	python $TERMUX_PREFIX/bin/searpc-codegen.py $TERMUX_PKG_SRCDIR/lib/rpc_table.py
}
