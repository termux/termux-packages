TERMUX_PKG_HOMEPAGE=https://github.com/svenstaro/miniserve
TERMUX_PKG_DESCRIPTION="Tool to serve files and dirs over HTTP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.23.2"
TERMUX_PKG_SRCURL=https://github.com/svenstaro/miniserve/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9817f9083cf338d5f165633865d4b5e6c8e7df6267e04c320119548253fb13cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	export CFLAGS="${TARGET_CFLAGS}"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/socket2-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		local p="socket2-0.5.2-src-sys-unix.rs.diff32"
		local d
		for d in $CARGO_HOME/registry/src/*/socket2-*; do
			patch --silent -p1 -d ${d} \
				< "$TERMUX_PKG_BUILDER_DIR/${p}" || :
		done
	fi

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
