TERMUX_PKG_HOMEPAGE=https://github.com/Bhupesh-V/ugit
TERMUX_PKG_DESCRIPTION="ugit helps you undo your last git command with grace. Your damage control git buddy"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="5.5"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2bfdb6315f13bd503095aaf301fa0407a6b3fba279739783c48ab093b8ec146c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ENABLE_CLANG16_PORTING=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, fzf, ncurses-utils'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	local bin="$(basename $TERMUX_PKG_HOMEPAGE)"
	install -D "$bin" -t "$TERMUX_PREFIX/bin"
	ln -sf "$TERMUX_PREFIX/bin/$bin"  "$TERMUX_PREFIX/bin/gitundo"
}
