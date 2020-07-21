TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/libsearpc
TERMUX_PKG_DESCRIPTION="A simple C language RPC framework (mainly for seafile)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/haiwen/libsearpc/archive/v${TERMUX_PKG_VERSION}-latest.tar.gz
TERMUX_PKG_SHA256=08411c2581e4c3967f4590f25a357952cd7d71d83229171a3c1e1f321d457806
TERMUX_PKG_DEPENDS="glib, libjansson"
TERMUX_PKG_BREAKS="libsearpc-dev"
TERMUX_PKG_REPLACES="libsearpc-dev"

termux_step_post_get_source() {
	./autogen.sh
}
