TERMUX_PKG_HOMEPAGE="https://dandavison.github.io/delta/"
TERMUX_PKG_DESCRIPTION="A syntax-highlighter for git and diff output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.18.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/dandavison/delta/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git, libgit2, oniguruma"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export RUSTONIG_SYSTEM_LIBONIG=1

	rm -f Makefile release.Makefile
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"

	local _ORIG_CFLAGS="$CFLAGS"
	termux_setup_rust
	export CFLAGS="$_ORIG_CFLAGS"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in "$CARGO_HOME"/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done
}

termux_step_post_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/delta

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/delta
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_delta
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/delta.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		delta --generate-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/delta
		delta --generate-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_delta
		delta --generate-completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/delta.fish
	EOF
}
