TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/libsearpc
TERMUX_PKG_DESCRIPTION="A simple C language RPC framework (mainly for seafile)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_SRCURL=https://github.com/haiwen/libsearpc/archive/v${TERMUX_PKG_VERSION}-latest.tar.gz
TERMUX_PKG_SHA256=36ebf5c5b6cb6a5b02043a0e9d3a243656a522457258c0b03a210f017800aafc
TERMUX_PKG_DEPENDS="glib, libjansson"
TERMUX_PKG_BREAKS="libsearpc-dev"
TERMUX_PKG_REPLACES="libsearpc-dev"

termux_step_post_extract_package() {
	./autogen.sh
}
