TERMUX_PKG_HOMEPAGE=https://await-cli.app/
TERMUX_PKG_DESCRIPTION="Runs list of commands in parallel and waits for their termination"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.5"
TERMUX_PKG_SRCURL=https://github.com/slavaGanzin/await/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f53fdcde929471078da6a0e9257dec17dea7b3d86045bb4038d38592e416ae6
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS "$TERMUX_PKG_SRCDIR"/await.c -o await $LDFLAGS
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin await
}
