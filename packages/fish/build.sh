TERMUX_PKG_HOMEPAGE=https://fishshell.com/
TERMUX_PKG_DESCRIPTION="The user-friendly command line shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.0
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/releases/download/$TERMUX_PKG_VERSION/fish-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=97044d57773ee7ca15634f693d917ed1c3dc0fa7fde1017f1626d60b83ea6181
TERMUX_PKG_AUTO_UPDATE=true
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line.
# man is needed since fish calls apropos during command completion.
TERMUX_PKG_DEPENDS="libc++, ncurses, libandroid-support, ncurses-utils, man, bc, pcre2, libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
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
