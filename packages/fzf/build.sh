TERMUX_PKG_HOMEPAGE=https://github.com/junegunn/fzf
TERMUX_PKG_DESCRIPTION="Command-line fuzzy finder"
TERMUX_PKG_VERSION=0.16.1
TERMUX_PKG_SRCURL=https://github.com/junegunn/fzf/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=fzf-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="bash, ncurses"

termux_step_make_install () {
	termux_setup_golang
	export CGO_CFLAGS="-I$TERMUX_PREFIX/include"
	export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"

	cd $TERMUX_PKG_SRCDIR/src
	make android-build

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	cp $TERMUX_PKG_SRCDIR/bin/fzf-tmux $TERMUX_PREFIX/bin

	# Install the fzf.1 man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/man/man1/fzf.1 $TERMUX_PREFIX/share/man/man1/

	# Install the vim plugin:
	mkdir -p $TERMUX_PREFIX/share/vim/vim80/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/vim/vim80/plugin/fzf.vim

	# Install bash, zsh and fish helper scripts:
	mkdir -p "$TERMUX_PREFIX/share/fzf"
	cp $TERMUX_PKG_SRCDIR/shell/* "$TERMUX_PREFIX/share/fzf"

	# Install the nvim plugin:
	mkdir -p $TERMUX_PREFIX/share/nvim/runtime/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/nvim/runtime/plugin/
}

termux_step_post_massage () {
	# Remove so that the vim build doesn't add it to vim-runtime:
	rm $TERMUX_PREFIX/share/vim/vim80/plugin/fzf.vim
}
