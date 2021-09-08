TERMUX_PKG_HOMEPAGE="https://helix-editor.com/"
TERMUX_PKG_DESCRIPTION="A post-modern modal text editor written in rust"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION="23.05"
TERMUX_PKG_SRCURL="git+https://github.com/helix-editor/helix"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_SUGGESTS="helix-grammars"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
opt/helix/runtime/grammars/sources/
"

termux_step_make() {
	termux_setup_rust

	cargo build --jobs "${TERMUX_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	local datadir="${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${datadir}"

	cat >"${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/bin/hx" <<-EOF
		#!${TERMUX_PREFIX}/bin/sh
		HELIX_RUNTIME=${datadir}/runtime exec ${datadir}/hx "\$@"
	EOF
	chmod 0700 "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/bin/hx"

	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/hx "${TERMUX_PKG_MASSAGEDIR}/${datadir}/hx"

	cp -r ./runtime "${TERMUX_PKG_MASSAGEDIR}/${datadir}"
	find "${TERMUX_PKG_MASSAGEDIR}/${datadir}"/runtime/grammars -type f -name "*.so" -exec chmod 0700 {} \;
}
