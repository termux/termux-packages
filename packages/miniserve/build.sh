TERMUX_PKG_HOMEPAGE=https://github.com/svenstaro/miniserve
TERMUX_PKG_DESCRIPTION="Tool to serve files and dirs over HTTP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.0"
TERMUX_PKG_SRCURL=https://github.com/svenstaro/miniserve/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8816d8379321fd3160f57d771b4b743f04bab57dd1ec8d04def0b15a96bde87c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=libbz2
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_post_make_install() {
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/miniserve
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_miniserve
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/miniserve.fish
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

	# Warn user on default behaviour of miniserve.
	echo
	echo "WARNING: miniserve follows symlinks in selected directory by default. Consider aliasing it with '--no-symlinks' for safety."
	echo "See: https://github.com/svenstaro/miniserve/issues/498"
	echo
	EOF
}
