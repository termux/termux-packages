TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parallel/
TERMUX_PKG_DESCRIPTION="GNU Parallel is a shell tool for executing jobs in parallel using one or more machines"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20230422
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parallel/parallel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9106593d09dc4de0e094b7b14390a309d8fcb1d27104a53814d16937dcbae3c2
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR"

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/parallel

	mkdir -p "$TERMUX_PREFIX"/share/zsh/site-functions

	cat <<-EOF >"$TERMUX_PREFIX"/share/zsh/site-functions/_parallel
		#compdef parallel
		(( $+functions[_comp_parallel] )) ||
			eval "$(parallel --shell-completion auto)" &&
			comp_parallel
	EOF
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		parallel --shell-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/parallel
	EOF
}
