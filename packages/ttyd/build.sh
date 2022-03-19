TERMUX_PKG_HOMEPAGE=https://tsl0922.github.io/ttyd/
TERMUX_PKG_DESCRIPTION="Command-line tool for sharing terminal over the web"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.3
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/tsl0922/ttyd/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="json-c, libcap, libuv, libwebsockets, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_XXD=$TERMUX_PKG_TMPDIR/xxd"

termux_step_pre_configure() {
	termux_download \
		https://raw.githubusercontent.com/vim/vim/v8.1.0427/src/xxd/xxd.c \
		$TERMUX_PKG_CACHEDIR/xxd.c \
		021b38e02cd31951a80ef5185271d71f2def727eb8ff65b7a07aecfbd688b8e1
	gcc $TERMUX_PKG_CACHEDIR/xxd.c -o $TERMUX_PKG_TMPDIR/xxd
}
