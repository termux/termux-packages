TERMUX_PKG_HOMEPAGE=https://await-cli.app/
TERMUX_PKG_DESCRIPTION="Runs list of commands in parallel and waits for their termination"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.2"
TERMUX_PKG_SRCURL=https://github.com/slavaGanzin/await/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2e761fd88dcca96b1bc123994a332af822d5fcae4894dc26b9b7601358b1289e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS "$TERMUX_PKG_SRCDIR"/await.c -o await $LDFLAGS
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin await
}
