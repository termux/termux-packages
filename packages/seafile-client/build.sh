TERMUX_PKG_HOMEPAGE=http://seafile.com
TERMUX_PKG_DESCRIPTION="Seafile is a file syncing and sharing software with file encryption and group sharing"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=7.0.1
TERMUX_PKG_SRCURL=https://github.com/haiwen/seafile/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c79a186e3a512454cb65d863bd45ecc8ae2c66a0dd2010533f3fed7862fa92f8
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
