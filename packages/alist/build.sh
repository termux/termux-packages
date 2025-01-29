TERMUX_PKG_HOMEPAGE=https://alist.nn.ci
TERMUX_PKG_DESCRIPTION="A file list program that supports multiple storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="3.42.0"
_ALIST_WEB_VERSION="3.42.0"
TERMUX_PKG_SRCURL=(
	https://github.com/AlistGo/alist/archive/v${TERMUX_PKG_VERSION}.tar.gz
	https://github.com/AlistGo/alist-web/releases/download/${_ALIST_WEB_VERSION}/dist.tar.gz
)
TERMUX_PKG_SHA256=(
	e9d0370c6bbeaf7e3d25b8865b000892bcc1d61f3604b744b6778ba46281dc9a
	685dd13b4da39e253085d82fd11074f051b1cbc40238479421763b3d2e49b2f0
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

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
	curl -sLo "${tmpdir}/alist-linux-amd64.tar.gz" "https://github.com/alist-org/alist/releases/download/v${latest_tag}/alist-linux-amd64.tar.gz"
	tar -C "${tmpdir}" -xf "${tmpdir}/alist-linux-amd64.tar.gz"
	chmod +x "${tmpdir}/alist"
	local latest_web_version="$("${tmpdir}"/alist version | grep "WebVersion:" | cut -d ' ' -f 2)"

	curl -sLo "${tmpdir}/src" "https://github.com/alist-org/alist/archive/v${latest_tag}.tar.gz"
	curl -sLo "${tmpdir}/web" "https://github.com/alist-org/alist-web/releases/download/${latest_web_version}/dist.tar.gz"
	local -a sha=(
		"$(sha256sum "${tmpdir}/src" | cut -d ' ' -f 1)"
		"$(sha256sum "${tmpdir}/web" | cut -d ' ' -f 1)"
	)

	sed \
		-e "s|^_ALIST_WEB_VERSION=.*|_ALIST_WEB_VERSION=\"${latest_web_version}\"|" \
		-e "s|^\t${TERMUX_PKG_SHA256[0]}.*|\t${sha[0]}|" \
		-e "s|^\t${TERMUX_PKG_SHA256[1]}.*|\t${sha[1]}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	printf '%s %s\n' 'ALIST_VERSION     :' "${latest_tag}"
	printf '%s %s\n' 'ALIST_CHECKSUM    :' "${sha[0]}"
	printf '%s %s\n' 'ALIST_WEB_VERSION :' "${latest_web_version}"
	printf '%s %s\n' 'ALIST_WEB_CHECKSUM:' "${sha[1]}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_post_get_source() {
	rm -rf public/dist
	mv -f dist public
}

termux_step_make() {
	termux_setup_golang

	local ldflags
	local _builtAt=$(date +'%F %T %z')
	local _goVersion=$(go version | sed 's/go version //')
	local _gitAuthor="Andy Hsu <i@nn.ci>"
	local _gitCommit=$(git ls-remote https://github.com/alist-org/alist refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	export CGO_ENABLED=1

	ldflags="\
	-w -s \
	-X 'github.com/alist-org/alist/v3/internal/conf.BuiltAt=$_builtAt' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GoVersion=$_goVersion' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GitAuthor=$_gitAuthor' \
	-X 'github.com/alist-org/alist/v3/internal/conf.GitCommit=$_gitCommit' \
	-X 'github.com/alist-org/alist/v3/internal/conf.Version=$TERMUX_PKG_VERSION' \
	-X 'github.com/alist-org/alist/v3/internal/conf.WebVersion=$_ALIST_WEB_VERSION' \
	"
	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags" -tags=jsoniter
}

termux_step_make_install() {
	install -Dm700 ./"${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}"/bin

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/alist.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_alist"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/alist.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		alist completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/alist.bash
		alist completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_alist
		alist completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/alist.fish
	EOF
}
