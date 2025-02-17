TERMUX_PKG_HOMEPAGE=https://seafile.com
TERMUX_PKG_DESCRIPTION="Seafile is a file syncing and sharing software with file encryption and group sharing"
# License: GPL-2.0-with-OpenSSL-exception
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.0.12"
TERMUX_PKG_SRCURL=https://github.com/haiwen/seafile/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2e647274dbebc99d29fb73596ee0125b3bae6aee6ad22bc4627812e67fd9fc72
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="argon2, glib, libcurl, libevent, libjansson, libsearpc, libsqlite, libuuid, libwebsockets, openssl, python, zlib"
TERMUX_PKG_BREAKS="seafile-client-dev, ccnet"
TERMUX_PKG_REPLACES="seafile-client-dev, ccnet"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-python_prefix=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	./autogen.sh
	export CPPFLAGS="-I$TERMUX_PKG_SRCDIR/lib $CPPFLAGS"
}

termux_step_post_configure() {
	#the package has trouble to prepare some headers
	cd $TERMUX_PKG_SRCDIR/lib
	python $TERMUX_PREFIX/bin/searpc-codegen.py $TERMUX_PKG_SRCDIR/lib/rpc_table.py
}
