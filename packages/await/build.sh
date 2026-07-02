TERMUX_PKG_HOMEPAGE=https://github.com/slavaGanzin/await
TERMUX_PKG_DESCRIPTION="Runs list of commands in parallel and waits for their termination"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.0"
TERMUX_PKG_SRCURL=https://github.com/slavaGanzin/await/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a9f3d4184a0a459a9cc4add27d7a3c364e85244e5d1cc6c3b999b5d22d04f6e9
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS "$TERMUX_PKG_SRCDIR"/await.c -o await $LDFLAGS
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" await
}
