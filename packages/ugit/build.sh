TERMUX_PKG_HOMEPAGE=https://github.com/Bhupesh-V/ugit
TERMUX_PKG_DESCRIPTION="ugit helps you undo your last git command with grace. Your damage control git buddy"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="5.3"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c83183ac91becc2ee281da5d8e67d2a25b7bd750f437e5d3f0214051c7162aa9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, fzf, ncurses-utils, ugit'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	local bin="$(basename $TERMUX_PKG_HOMEPAGE)"
	install -D "$bin" -t "$TERMUX_PREFIX/bin"
	ln -sf "$TERMUX_PREFIX/bin/$bin"  "$TERMUX_PREFIX/bin/gitundo"
}
