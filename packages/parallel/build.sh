TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20211022
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parallel/parallel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=da7190fce22a9cda97b2ce36df112a2c634f1b4a5591af343b928253e996de9b
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		mkdir -p ${TERMUX_PREFIX}/share/bash-completion/completions
		mkdir -p ${TERMUX_PREFIX}/share/zsh/site-functions
		parallel --shell-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/parallel
		parallel --shell-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_parallel
	EOF

	cat <<-EOF >./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/parallel
		rm -f ${TERMUX_PREFIX}/share/zsh/site-functions/_parallel
	EOF
}
