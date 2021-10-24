TERMUX_PKG_HOMEPAGE=https://github.com/svenstaro/miniserve
TERMUX_PKG_DESCRIPTION="Tool to serve files via HTTP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/svenstaro/miniserve/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4b961a45b8ef645f4f25c5e860d7464bdb5712a7a49275a6d815f4c1194bbf60
TERMUX_PKG_DEPENDS=libbz2
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh

	# Generating shell completions.
	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
	mkdir -p $TERMUX_PREFIX/share/zsh/site-functions
	mkdir -p $TERMUX_PREFIX/share/fish/vendor_completions.d

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
