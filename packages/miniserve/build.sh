TERMUX_PKG_HOMEPAGE=https://github.com/svenstaro/miniserve
TERMUX_PKG_DESCRIPTION="Tool to serve files and dirs over HTTP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.31.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/svenstaro/miniserve/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a4773ae5a6fbc45baf15a5dcb54fd6b7e0151f2fde25c26ddafc0f95b7d26c32
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	rm -f Makefile
}

termux_step_post_make_install() {
	# shell completions
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/miniserve
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_miniserve
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/miniserve.fish

	# manpage
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/man/man1/miniserve.1
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh

	miniserve --print-completions bash \
		> "$TERMUX_PREFIX"/share/bash-completion/completions/miniserve
	miniserve --print-completions zsh \
		> "$TERMUX_PREFIX"/share/zsh/site-functions/_miniserve
	miniserve --print-completions fish \
		> "$TERMUX_PREFIX"/share/fish/vendor_completions.d/miniserve.fish
	miniserve --print-manpage \
		> "$TERMUX_PREFIX"/share/man/man1/miniserve.1

	# Warn user on default behaviour of miniserve.
	echo
	echo "WARNING: miniserve follows symlinks in selected directory by default. Consider aliasing it with '--no-symlinks' for safety."
	echo "See: https://github.com/svenstaro/miniserve/issues/498"
	echo
	EOF
}
