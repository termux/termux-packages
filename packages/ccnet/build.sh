TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/ccnet
TERMUX_PKG_DESCRIPTION="Ccnet is a framework for writing networked applications in C"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.1.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/haiwen/ccnet/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b55636bf95232dc1db70d3604d0bebb7c3d730292d15b9b6c5b951307eb69762
TERMUX_PKG_DEPENDS="libuuid, libevent, libsearpc, libsqlite, openssl"
TERMUX_PKG_BREAKS="ccnet-dev"
TERMUX_PKG_REPLACES="ccnet-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_configure() {
	# the package has trouble to prepare some headers
	cd $TERMUX_PKG_SRCDIR/lib
	python $TERMUX_PREFIX/bin/searpc-codegen.py ../lib/rpc_table.py
}
