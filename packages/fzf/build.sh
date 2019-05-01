TERMUX_PKG_HOMEPAGE=https://github.com/junegunn/fzf
TERMUX_PKG_DESCRIPTION="Command-line fuzzy finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_SHA256=5406d181785ea17b007544082b972ae004b62fb19cdb41f25e265ea3cc8c2d9d
TERMUX_PKG_SRCURL=https://github.com/junegunn/fzf/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC="yes"
# Depend on findutils as fzf uses the -fstype option, which busybox
# find does not support, when invoking find:
TERMUX_PKG_DEPENDS="bash, findutils"

termux_step_make() {
	:
}

termux_step_make_install() {
	termux_setup_golang
	export CGO_CFLAGS="-I$TERMUX_PREFIX/include"
	export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"

	# See the fzf Makefile:
	local _BINARY="target/fzf-${GOOS}_"
	if [ $TERMUX_ARCH = "arm" ]; then
		_BINARY+="arm7"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_BINARY+="386"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		_BINARY+="amd64"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_BINARY+="arm8"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	LDFLAGS="-pie" make $_BINARY
	cp $_BINARY $TERMUX_PREFIX/bin/fzf

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	cp $TERMUX_PKG_SRCDIR/bin/fzf-tmux $TERMUX_PREFIX/bin

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
	mkdir -p "$TERMUX_PREFIX/share/fzf"
	cp $TERMUX_PKG_SRCDIR/shell/* "$TERMUX_PREFIX/share/fzf"

	# Install the nvim plugin:
	mkdir -p $TERMUX_PREFIX/share/nvim/runtime/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/nvim/runtime/plugin/
}

termux_step_post_massage() {
	# Remove so that the vim build doesn't add it to vim-runtime:
	rm $TERMUX_PREFIX/share/vim/vim81/plugin/fzf.vim
}
