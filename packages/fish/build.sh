TERMUX_PKG_HOMEPAGE=http://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/releases/download/$TERMUX_PKG_VERSION/fish-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f8c0edadca2de379ccf305aeace660a9255fa2180c72e85e97705a24c256b2a5
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line.
# man is needed since fish calls apropos during command completion.
TERMUX_PKG_DEPENDS="ncurses, libandroid-support, ncurses-utils, man, bc"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=fish-$TERMUX_PKG_VERSION
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__proc_self_stat=yes"

termux_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"

	# The column(1) utility is used by oh-my-fish, so we bundle column.c from bsdmainutils with it:
	$CC $CFLAGS $LDFLAGS -DLINE_MAX=_POSIX2_LINE_MAX $TERMUX_PKG_BUILDER_DIR/column.c -o $TERMUX_PREFIX/bin/column
}

termux_step_post_make_install () {
	cat >> $TERMUX_PREFIX/etc/fish/config.fish <<HERE

function __fish_command_not_found_handler --on-event fish_command_not_found
	$TERMUX_PREFIX/libexec/termux/command-not-found \$argv[1]
end
HERE
}
