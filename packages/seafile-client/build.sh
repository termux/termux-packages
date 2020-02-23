TERMUX_PKG_HOMEPAGE=http://seafile.com
TERMUX_PKG_DESCRIPTION="Seafile is a file syncing and sharing software with file encryption and group sharing"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=7.0.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/haiwen/seafile/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a7f37b555b5e8750194db9ae8041d2b0ed0035b3fc832112d4a891e02b00488
TERMUX_PKG_DEPENDS="ccnet, libcurl, python"
TERMUX_PKG_BREAKS="seafile-client-dev"
TERMUX_PKG_REPLACES="seafile-client-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
	export CPPFLAGS="-I$TERMUX_PKG_SRCDIR/lib $CPPFLAGS"
}

termux_step_post_configure() {
	# the package has trouble to prepare some headers
	cd $TERMUX_PKG_SRCDIR/lib
	python $TERMUX_PREFIX/bin/searpc-codegen.py $TERMUX_PKG_SRCDIR/lib/rpc_table.py
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	pip install future
	EOF
}
