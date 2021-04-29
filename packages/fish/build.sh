TERMUX_PKG_HOMEPAGE=https://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/releases/download/$TERMUX_PKG_VERSION/fish-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5944da1a8893d11b0828a4fd9136ee174549daffb3d0adfdd8917856fe6b4009
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line.
# man is needed since fish calls apropos during command completion.
TERMUX_PKG_DEPENDS="libc++, ncurses, libandroid-support, ncurses-utils, man, bc, pcre2, libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
# Prevent clash with ripgrep package:
TERMUX_PKG_RM_AFTER_INSTALL="share/fish/completions/rg.fish"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_DOCS=OFF
"

termux_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_post_make_install() {
	cat >> $TERMUX_PREFIX/etc/fish/config.fish <<HERE

function __fish_command_not_found_handler --on-event fish_command_not_found
	$TERMUX_PREFIX/libexec/termux/command-not-found \$argv[1]
end
HERE
}
