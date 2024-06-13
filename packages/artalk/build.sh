TERMUX_PKG_HOMEPAGE=https://artalk.js.org/
TERMUX_PKG_DESCRIPTION="A self-hosted comment system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Moraxyc <termux@qaq.li>"
TERMUX_PKG_VERSION=2.8.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://github.com/ArtalkJS/Artalk/archive/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/ArtalkJS/Artalk/releases/download/v${TERMUX_PKG_VERSION}/artalk_ui.tar.gz)
TERMUX_PKG_SHA256=(1d6abad32da1fe88dcc38bda3a61070820126598b2fdba2c9f5808b72d0d0fd1
                   dd183998216280b919f97f05c5ee80d7a4c777d8fa85c4d830400a5354ab2ccc)
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL[0]}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	(( ${#latest_tag} )) || {
		printf '%s\n' \
		'WARN: Auto update failure!' \
		"latest_tag=${latest_tag}"
	return
	} >&2

	if [[ "${latest_tag}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	local tmpdir
	tmpdir="$(mktemp -d)"
	curl -so "${tmpdir}/src" "https://github.com/ArtalkJS/Artalk/archive/v${latest_tag}.tar.gz"
	curl -so "${tmpdir}/ui"  "https://github.com/ArtalkJS/Artalk/releases/download/v${latest_tag}/artalk_ui.tar.gz"
	local -a sha=(
		"$(sha256sum "${tmpdir}/src" | cut -d ' ' -f 1)"
		"$(sha256sum "${tmpdir}/ui"  | cut -d ' ' -f 1)"
	)

	sed \
		-e "s|${TERMUX_PKG_SHA256[0]}|${sha[0]}|" \
		-e "s|${TERMUX_PKG_SHA256[1]}|${sha[1]}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	printf '%s\n' 'INFO: Generated checksums:' "${sha[@]}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_post_get_source() {
	mv artalk_ui/* public
}

termux_step_make() {
	termux_setup_golang
	local _gitCommit ldflags

	export CGO_ENABLED=1
	_gitCommit=$(git ls-remote https://github.com/ArtalkJS/Artalk refs/tags/v$TERMUX_PKG_VERSION | head -c 7)

	ldflags="\
	-w -s \
	-X github.com/ArtalkJS/Artalk/internal/config.Version=$TERMUX_PKG_VERSION \
	-X github.com/ArtalkJS/Artalk/internal/config.CommitHash=$_gitCommit \
	"
	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags"
}

termux_step_make_install() {
	install -Dm755 ./"${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}"/bin

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/artalk.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_artalk"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/artalk.fish"

}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		artalk completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/artalk.bash
		artalk completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_artalk
		artalk completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/artalk.fish
	EOF
}
