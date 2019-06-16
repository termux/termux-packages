TERMUX_PKG_HOMEPAGE=https://github.com/vapier/ncompress
TERMUX_PKG_DESCRIPTION="The classic unix compression utility which can handle the ancient .Z archive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.2.4.5
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/vapier/ncompress/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f575bbcdd5f844ce22d753b9acd23d2a6b73ffc15f204bebbaf8bd6f6574903b
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 compress "$TERMUX_PREFIX"/bin/
	mkdir -p "$TERMUX_PREFIX"/share/man/man1/
	install -Dm600 compress.1 "$TERMUX_PREFIX"/share/man/man1/
}
