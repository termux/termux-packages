TERMUX_PKG_HOMEPAGE=http://seafile.com
TERMUX_PKG_DESCRIPTION="Seafile is a file syncinc and sharing software with file encryption and group sharing."
TERMUX_PKG_VERSION=6.1.7
TERMUX_PKG_SHA256=91a4b923155f3ae7c7391d272afec8eebc40866767e45b1ce5a78783a3523fa4
TERMUX_PKG_SRCURL=https://github.com/haiwen/seafile/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ccnet, libcurl"
TERMUX_PKG_BUILD_IN_SRC=yes


termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_configure() {
	# the package has trouble to prepare some headers
	cd lib
	python $TERMUX_PREFIX/bin/searpc-codegen.py $TERMUX_PKG_SRCDIR/lib/rpc_table.py
	cd ..
}
