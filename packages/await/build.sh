TERMUX_PKG_HOMEPAGE=https://await-cli.app/
TERMUX_PKG_DESCRIPTION="Runs list of commands in parallel and waits for their termination"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.3"
TERMUX_PKG_SRCURL=https://github.com/slavaGanzin/await/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b41729baddf504260c497b33d4105fc776aaa57ed7c838c0c33f1339d00b6b17
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS "$TERMUX_PKG_SRCDIR"/await.c -o await $LDFLAGS
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin await
}
