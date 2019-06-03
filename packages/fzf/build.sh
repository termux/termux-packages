TERMUX_PKG_HOMEPAGE=https://github.com/junegunn/fzf
TERMUX_PKG_DESCRIPTION="Command-line fuzzy finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_SHA256=5406d181785ea17b007544082b972ae004b62fb19cdb41f25e265ea3cc8c2d9d
TERMUX_PKG_SRCURL=https://github.com/junegunn/fzf/archive/${TERMUX_PKG_VERSION}.tar.gz

# Depend on findutils as fzf uses the -fstype option, which busybox
# find does not support, when invoking find:
TERMUX_PKG_DEPENDS="bash, findutils"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p $GOPATH/src/github.com/junegunn
	ln -sf $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/junegunn/fzf

	cd $GOPATH/src/github.com/junegunn/fzf
	go get -d -v github.com/junegunn/fzf
	go build
}

termux_step_make_install() {
	cd $GOPATH/src/github.com/junegunn/fzf

	install -Dm700 fzf $TERMUX_PREFIX/bin/fzf

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	install -Dm700 $TERMUX_PKG_SRCDIR/bin/fzf-tmux $TERMUX_PREFIX/bin/fzf-tmux

	# Install the fzf.1 man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/man/man1/fzf.1 $TERMUX_PREFIX/share/man/man1/

	# Install the vim plugin:
	mkdir -p $TERMUX_PREFIX/share/vim/vim81/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/vim/vim81/plugin/fzf.vim

	# Install bash completion script:
	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions/
	cp $TERMUX_PKG_SRCDIR/shell/completion.bash $TERMUX_PREFIX/share/bash-completion/completions/fzf

	# Install the rest of the shell scripts:
	mkdir -p $TERMUX_PREFIX/share/fzf
	cp $TERMUX_PKG_SRCDIR/shell/* $TERMUX_PREFIX/share/fzf/

	# Install the nvim plugin:
	mkdir -p $TERMUX_PREFIX/share/nvim/runtime/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/nvim/runtime/plugin/
}

termux_step_post_massage() {
	# Remove so that the vim build doesn't add it to vim-runtime:
	rm $TERMUX_PREFIX/share/vim/vim81/plugin/fzf.vim
}
