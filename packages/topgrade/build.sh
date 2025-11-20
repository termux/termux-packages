TERMUX_PKG_HOMEPAGE=https://github.com/topgrade-rs/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="16.4.2"
TERMUX_PKG_SRCURL="https://github.com/topgrade-rs/topgrade/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e5a5727b0b33463c913992e05607aecd3157f469c283673f8eca992e9b9c535c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_get_source() {
	rm -f pyproject.toml
}

termux_step_post_massage() {
	mkdir -p ./share/bash-completion/completions
	mkdir -p ./share/zsh/site-functions
	mkdir -p ./share/fish/vendor_completions.d
	mkdir -p ./share/man/man1
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		${TERMUX_PREFIX}/bin/topgrade --gen-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/topgrade
		${TERMUX_PREFIX}/bin/topgrade --gen-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_topgrade
		${TERMUX_PREFIX}/bin/topgrade --gen-completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/topgrade.fish
		${TERMUX_PREFIX}/bin/topgrade --gen-manpage > ${TERMUX_PREFIX}/share/man/man1/topgrade.1
		exit 0
	EOF
	cat <<-EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/topgrade
		rm -f ${TERMUX_PREFIX}/share/zsh/site-functions/_topgrade
		rm -f ${TERMUX_PREFIX}/share/fish/vendor_completions.d/topgrade.fish
		rm -f ${TERMUX_PREFIX}/share/man/man1/topgrade.1
		exit 0
	EOF
}
