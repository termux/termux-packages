TERMUX_PKG_HOMEPAGE=https://github.com/slavaGanzin/await
TERMUX_PKG_DESCRIPTION="Runs list of commands in parallel and waits for their termination"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.0"
TERMUX_PKG_SRCURL=https://github.com/slavaGanzin/await/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=49acabc0c4859e4f0527cf40c0b06f88240c5dd70e662a63bf3eb853043917f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn"

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS "$TERMUX_PKG_SRCDIR"/await.c -o await $LDFLAGS -landroid-spawn
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" await
}
