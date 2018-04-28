TERMUX_PKG_HOMEPAGE=https://github.com/haiwen/libsearpc
TERMUX_PKG_DESCRIPTION="A simple C language RPC framework (mainly for seafile)"
TERMUX_PKG_VERSION=3.0.7
TERMUX_PKG_SHA256=efee6b495f93e70101c87849c78b135014dfd2f0e5c08dcfed9834def47cb939
TERMUX_PKG_SRCURL=https://github.com/haiwen/libsearpc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="glib, libjansson"
TERMUX_PKG_BUILD_DEPENDS="libtool, python, pkg-config"
TERMUX_PKG_HOSTBUILD=yes

termux_step_post_extract_package() {
	./autogen.sh
}

