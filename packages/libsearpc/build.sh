TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/libsearpc
TERMUX_PKG_DESCRIPTION="A simple C language RPC framework (mainly for seafile)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/haiwen/libsearpc/archive/v${TERMUX_PKG_VERSION}-latest.tar.gz
TERMUX_PKG_SHA256=e6b07e7c4ed9307f14bc4e470ed335df63e8f8fe1262a57ff5567ef218471403
TERMUX_PKG_DEPENDS="glib, libjansson"
TERMUX_PKG_BREAKS="libsearpc-dev"
TERMUX_PKG_REPLACES="libsearpc-dev"

termux_step_post_extract_package() {
	./autogen.sh
}
