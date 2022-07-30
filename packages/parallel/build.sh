TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parallel/
TERMUX_PKG_DESCRIPTION="GNU Parallel is a shell tool for executing jobs in parallel using one or more machines"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20220422
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parallel/parallel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=96e4b73fff1302fc141a889ae43ab2e93f6c9e86ac60ef62ced02dbe70b73ca7
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
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
		mkdir -p ${TERMUX_PREFIX}/share/bash-completion/completions
		parallel --shell-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/parallel
	EOF

	cat <<-EOF >./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/parallel
	EOF
}
