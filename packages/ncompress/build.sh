TERMUX_PKG_HOMEPAGE=https://github.com/vapier/ncompress
TERMUX_PKG_DESCRIPTION="The classic unix compression utility which can handle the ancient .Z archive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.2.4.6
TERMUX_PKG_SRCURL=https://github.com/vapier/ncompress/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fb7b6a00060bd4c6e35ba4cc96a5ca7e78c193e6267487dd53376d80e061836b
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/man/man1/
	install -Dm700 compress "$TERMUX_PREFIX"/bin/
	install -Dm600 compress.1 "$TERMUX_PREFIX"/share/man/man1/
}
