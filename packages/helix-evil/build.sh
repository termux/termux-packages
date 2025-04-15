TERMUX_PKG_HOMEPAGE="https://helix-editor.com/"
TERMUX_PKG_DESCRIPTION="A post-modern modal text editor written in rust"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.04.13"
# TERMUX_PKG_REVISION=1
# TERMUX_PKG_GIT_BRANCH="release-20250413"
TERMUX_PKG_VERSION=2025.04.13
TERMUX_PKG_SRCURL="https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-${TERMUX_PKG_VERSION//\.}.tar.gz"
TERMUX_PKG_SHA256="60e0aadf9e833e0b579028b7f21803722b3705d74dd062bac96ff8ac4da91a5a"
TERMUX_PKG_RECOMMENDS="clang"
TERMUX_PKG_SUGGESTS="helix-grammars, bash-completion, clangd, delve, elvish, lldb, nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
# TERMUX_PKG_RM_AFTER_INSTALL="opt/helix/runtime/grammars/sources/"
TERMUX_PKG_BREAKS=helix
TERMUX_PKG_REPLACES=helix

termux_step_pre_configure() {
	termux_setup_rust
	# clash with rust host build
	unset CFLAGS
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	local datadir="${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}"
	mkdir -p "${datadir}"

	cat >"${TERMUX_PREFIX}/bin/hx" <<-EOF
	#!${TERMUX_PREFIX}/bin/sh
	HELIX_RUNTIME=${datadir}/runtime exec ${datadir}/hx "\$@"
	EOF
	chmod 0700 "${TERMUX_PREFIX}/bin/hx"

	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/hx "${datadir}/hx"

	#cp -r ./runtime "${datadir}"
	#find "${datadir}"/runtime/grammars -type f -name "*.so" -exec chmod 0600 "{}" \;

	install -Dm 0644 "contrib/completion/hx.zsh" "${TERMUX_PREFIX}/share/zsh/site-functions/_hx"
	install -Dm 0644 "contrib/completion/hx.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/hx"
	install -Dm 0644 "contrib/completion/hx.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/hx.fish"
}
