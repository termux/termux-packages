TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/libsearpc
TERMUX_PKG_DESCRIPTION="A simple C language RPC framework (mainly for seafile)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.3.0
TERMUX_PKG_SRCURL=https://github.com/haiwen/libsearpc/archive/refs/tags/v${TERMUX_PKG_VERSION:2:3}-latest.tar.gz
TERMUX_PKG_SHA256=7f800339ff712dbea024e7bd8b8aca989cd235f0a366dde3b56936192d358ad3
TERMUX_PKG_DEPENDS="glib, libjansson, python"
TERMUX_PKG_BREAKS="libsearpc-dev"
TERMUX_PKG_REPLACES="libsearpc-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-compile-demo=no
"

termux_step_post_get_source() {
	./autogen.sh
}

termux_step_pre_configure() {
	termux_setup_python_pip
	export PYTHON="cross-python"
}
