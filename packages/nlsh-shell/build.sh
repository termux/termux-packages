TERMUX_PKG_MAINTAINER="Tarzarov588"
TERMUX_PKG_HOMEPAGE=https://github.com/tarzarov588/nlsh-shell
TERMUX_PKG_DESCRIPTION="Configurable shell for Termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/tarzarov588/nlsh-shell/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba22833bfe949feba2bf1c1d591ac695fa3a4ba5add708b3a8ee2b8560e3a140
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_SUGGESTS="zsh"

termux_step_make() {
	"$CC" $CPPFLAGS $CFLAGS -Wall -Wextra \
		"$TERMUX_PKG_SRCDIR/src/main.c" \
		$LDFLAGS -o "$TERMUX_PKG_BUILDDIR/nlsh"
}

termux_step_make_install() {
	install -Dm755 "$TERMUX_PKG_BUILDDIR/nlsh" \
		"$TERMUX_PREFIX/bin/nlsh"
}
