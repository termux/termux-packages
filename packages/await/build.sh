TERMUX_PKG_HOMEPAGE=https://github.com/slavaGanzin/await
TERMUX_PKG_DESCRIPTION="Runs list of commands in parallel and waits for their termination"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL=https://github.com/slavaGanzin/await/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2333b49c56cbea5d033162a81ca7bc1aca9436500f1d32740c57901b1ce9a617
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn"

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS "$TERMUX_PKG_SRCDIR"/await.c -o await $LDFLAGS -landroid-spawn
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" await
}
