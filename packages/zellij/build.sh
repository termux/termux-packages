TERMUX_PKG_HOMEPAGE="https://zellij.dev/"
TERMUX_PKG_DESCRIPTION="A terminal workspace with batteries included"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Jonathan Lei <me@xjonathan.dev>"
TERMUX_PKG_VERSION="0.42.1"
TERMUX_PKG_SRCURL="https://github.com/zellij-org/zellij/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e9516879483c1bb617a13e6278878883943c05f87bdc41fc02cc550a7b06c0b4
TERMUX_PKG_BUILD_DEPENDS="openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# wasmer doesn't support these platforms yet
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust
	export OPENSSL_NO_VENDOR=1
}

termux_step_make() {
	cargo build --jobs ${TERMUX_PKG_MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
}

termux_step_make_install() {
	install -Dm700 -t ${TERMUX_PREFIX}/bin target/${CARGO_TARGET_NAME}/release/zellij

	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/bash-completion/completions/zellij.bash
	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/zsh/site-functions/_zellij
	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/fish/vendor_completions.d/zellij.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		zellij setup --generate-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/zellij.bash
		zellij setup --generate-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_zellij
		zellij setup --generate-completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/zellij.fish
	EOF
}
