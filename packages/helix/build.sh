TERMUX_PKG_HOMEPAGE="https://helix-editor.com/"
TERMUX_PKG_DESCRIPTION="A post-modern modal text editor written in rust"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION="24.03"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="git+https://github.com/helix-editor/helix"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_SUGGESTS="helix-grammars"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
opt/helix/runtime/grammars/sources/
"

termux_step_make_install() {
	termux_setup_rust

	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release

	local datadir="${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}"
	mkdir -p "${datadir}"

	cat >"${TERMUX_PREFIX}/bin/hx" <<-EOF
		#!${TERMUX_PREFIX}/bin/sh
		HELIX_RUNTIME=${datadir}/runtime exec ${datadir}/hx "\$@"
	EOF
	chmod 0700 "${TERMUX_PREFIX}/bin/hx"

	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/hx "${datadir}/hx"

	cp -r ./runtime "${datadir}"
	find "${datadir}"/runtime/grammars -type f -name "*.so" -exec chmod 0700 {} \;

	install -Dm 0644 "contrib/completion/hx.zsh" "${TERMUX_PREFIX}/share/zsh/site-functions/_hx"
	install -Dm 0644 "contrib/completion/hx.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/hx"
	install -Dm 0644 "contrib/completion/hx.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/hx.fish"
}
