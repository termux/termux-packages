TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/ccnet
TERMUX_PKG_DESCRIPTION="Ccnet is a framework for writing networked applications in C"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=6.1.7
TERMUX_PKG_SRCURL=https://github.com/haiwen/ccnet/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f9c81586181a8f331d3b00f334003e6b3f1af774f647cba30d5c9f9c546f7fce
TERMUX_PKG_DEPENDS="libuuid, libevent, libsearpc, libsqlite, openssl"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_configure() {
	# the package has trouble to prepare some headers
	cd $TERMUX_PKG_SRCDIR/lib
	python $TERMUX_PREFIX/bin/searpc-codegen.py ../lib/rpc_table.py
}
