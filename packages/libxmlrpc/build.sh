TERMUX_PKG_HOMEPAGE="https://xmlrpc-c.sourceforge.io/"
TERMUX_PKG_DESCRIPTION="XML-RPC for C and C++"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="doc/COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.59.03"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/${TERMUX_PKG_VERSION}/xmlrpc-c-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=bdb71db42ab0be51591555885d11682b044c1034d4a3296401bf921ec0b233fe
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_BUILD_DEPENDS="libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-cgi-server
--disable-libwww-client
--disable-libxml2-backend
--disable-wininet-client
--enable-cplusplus
"

# separate host-build directory but build system does not support out-of-tree build
termux_step_host_build() {
	pushd $TERMUX_PKG_HOSTBUILD_DIR
	cp -r $TERMUX_PKG_SRCDIR/* .
	./configure

	# build only the required tool
	make -C lib/expat/gennmtab
	popd
}

termux_step_post_configure() {
	export GENNMTAB=$TERMUX_PKG_HOSTBUILD_DIR/lib/expat/gennmtab/gennmtab
}
