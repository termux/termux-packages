TERMUX_PKG_HOMEPAGE="https://helix-editor.com/"
TERMUX_PKG_DESCRIPTION="A post-modern modal text editor written in rust"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.07"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/helix-editor/helix/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0f466ed2de039a7eca6faf29fc0db712c92e1a59d0bdc7e8916c717ceee8b3b3
TERMUX_PKG_SUGGESTS="helix-grammars, nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
opt/helix/runtime/grammars/sources/
"

termux_step_pre_configure() {
	termux_setup_rust
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

	cp -r ./runtime "${datadir}"
	find "${datadir}"/runtime/grammars -type f -name "*.so" -exec chmod 0600 "{}" \;

	install -Dm 0644 "contrib/completion/hx.zsh" "${TERMUX_PREFIX}/share/zsh/site-functions/_hx"
	install -Dm 0644 "contrib/completion/hx.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/hx"
	install -Dm 0644 "contrib/completion/hx.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/hx.fish"
}
