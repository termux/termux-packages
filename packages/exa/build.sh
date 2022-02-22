TERMUX_PKG_HOMEPAGE=https://the.exa.website
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/ogham/exa/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib, libgit2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	CFLAGS="$CPPFLAGS"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	mkdir -p $TERMUX_PREFIX/share/man/man5
	pandoc --standalone --to man $TERMUX_PKG_SRCDIR/man/exa.1.md --output $TERMUX_PREFIX/share/man/man1/exa.1
	pandoc --standalone --to man $TERMUX_PKG_SRCDIR/man/exa_colors.5.md --output $TERMUX_PREFIX/share/man/man5/exa_colors.5

	# For 0.10.1, this is the location of the completion files,
	# but they were moved after the release
	if [ -f 'completions/completions.bash' ]; then
		install -Dm600 completions/completions.bash \
			$TERMUX_PREFIX/share/bash-completion/completions/exa
		install -Dm600 completions/completions.fish \
			$TERMUX_PREFIX/share/fish/vendor_completions.d/exa.fish
		install -Dm600 completions/completions.zsh \
			$TERMUX_PREFIX/share/zsh/site-functions/_exa
	else
		install -Dm600 completions/bash/exa \
			$TERMUX_PREFIX/share/bash-completion/completions/exa
		install -Dm600 completions/fish/exa.fish \
			$TERMUX_PREFIX/share/fish/vendor_completions.d/exa.fish
		install -Dm600 completions/zsh/_exa \
			$TERMUX_PREFIX/share/zsh/site-functions/_exa
	fi
}
