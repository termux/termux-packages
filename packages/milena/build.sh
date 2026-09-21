TERMUX_PKG_HOMEPAGE=https://github.com/46Neon/Milena
TERMUX_PKG_DESCRIPTION="Milena programming language for data analysis"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Milena contributors"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SRCURL="https://github.com/46Neon/Milena/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=21eb3cba83916e24198a68ed8f783442efbe4d01ca2236e36662d958b10d60de
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make TERMUX=1 CC="$CC" \
		CFLAGS="$CFLAGS -Iinclude -ffunction-sections -fdata-sections" \
		LDFLAGS="$LDFLAGS -lm -Wl,--gc-sections" all
}

termux_step_make_install() {
	install -Dm755 milena "$TERMUX_PREFIX/bin/milena"
	install -Dm644 README.md "$TERMUX_PREFIX/share/doc/milena/README.md"
}
