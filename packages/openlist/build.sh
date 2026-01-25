TERMUX_PKG_HOMEPAGE=https://oplist.org/
TERMUX_PKG_DESCRIPTION="A file list program that supports multiple storage"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="4.1.9"
_OPENLIST_WEB_VERSION="4.1.9"
TERMUX_PKG_SRCURL=(
	https://github.com/OpenListTeam/OpenList/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
	https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${_OPENLIST_WEB_VERSION}/openlist-frontend-dist-v${_OPENLIST_WEB_VERSION}.tar.gz
)
TERMUX_PKG_SHA256=(
	5171cef3b03f6b68af0e4886af7b6f5a6f9c103de41c3b831f46dcb3ddcc6f18
	03e9c57d614ee338441d38fa27af1435f34b2c508ce57e0bd75b91b24d934aec
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="alist"
TERMUX_PKG_REPLACES="alist"
TERMUX_PKG_PROVIDES="alist"
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL[0]}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	latest_tag="${latest_tag#v}"
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

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_tag}."
		return
	fi

	local tmpdir
	tmpdir="$(mktemp -d)"
	curl -sLo "${tmpdir}/openlist-linux-amd64.tar.gz" "https://github.com/OpenListTeam/OpenList/releases/download/v${latest_tag}/openlist-linux-amd64.tar.gz"
	tar -C "${tmpdir}" -xf "${tmpdir}/openlist-linux-amd64.tar.gz"
	chmod +x "${tmpdir}/openlist"
	local latest_web_version
	latest_web_version="$("${tmpdir}"/openlist version | grep "WebVersion:" | cut -d ' ' -f 2 | sed 's/^v//')"

	curl -sLo "${tmpdir}/src" "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v${latest_tag}.tar.gz"
	curl -sLo "${tmpdir}/web" "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${latest_web_version}/openlist-frontend-dist-v${latest_web_version}.tar.gz"
	local -a sha=(
		"$(sha256sum "${tmpdir}/src" | cut -d ' ' -f 1)"
		"$(sha256sum "${tmpdir}/web" | cut -d ' ' -f 1)"
	)

	sed \
		-e "s|^_OPENLIST_WEB_VERSION=.*|_OPENLIST_WEB_VERSION=\"${latest_web_version}\"|" \
		-e "s|^\t${TERMUX_PKG_SHA256[0]}.*|\t${sha[0]}|" \
		-e "s|^\t${TERMUX_PKG_SHA256[1]}.*|\t${sha[1]}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	printf '%s %s\n' 'OPENLIST_VERSION     :' "${latest_tag}"
	printf '%s %s\n' 'OPENLIST_CHECKSUM    :' "${sha[0]}"
	printf '%s %s\n' 'OPENLIST_WEB_VERSION :' "${latest_web_version}"
	printf '%s %s\n' 'OPENLIST_WEB_CHECKSUM:' "${sha[1]}"
	termux_pkg_upgrade_version "${latest_tag}"
}


termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"

	# Download and extract backend source code
	termux_download \
		"${TERMUX_PKG_SRCURL[0]}" \
		"$TERMUX_PKG_CACHEDIR"/"openlist-backend-src-v${TERMUX_PKG_VERSION}.tar.gz" \
		"${TERMUX_PKG_SHA256[0]}"
	tar xf \
		"$TERMUX_PKG_CACHEDIR"/"openlist-backend-src-v${TERMUX_PKG_VERSION}.tar.gz" \
		-C "$TERMUX_PKG_SRCDIR" --strip-components=1

	# Download and extract frontend dist files
	mkdir -p "$TERMUX_PKG_SRCDIR"/public/dist
	termux_download \
		"${TERMUX_PKG_SRCURL[1]}" \
		"$TERMUX_PKG_CACHEDIR"/"openlist-frontend-dist-v${_OPENLIST_WEB_VERSION}.tar.gz" \
		"${TERMUX_PKG_SHA256[1]}"
	tar xf \
		"$TERMUX_PKG_CACHEDIR"/"openlist-frontend-dist-v${_OPENLIST_WEB_VERSION}.tar.gz" \
		-C "$TERMUX_PKG_SRCDIR"/public/dist
}

termux_step_make() {
	termux_setup_golang

	local ldflags
	local _builtAt=$(date +'%F %T %z')
	local _goVersion=$(go version | sed 's/go version //')
	local _gitAuthor="The OpenList Projects Contributors <noreply@openlist.team>"
	local _gitCommit=$(git ls-remote https://github.com/OpenListTeam/OpenList refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	export CGO_ENABLED=1

	ldflags="\
	-w -s \
	-X 'github.com/OpenListTeam/OpenList/internal/conf.BuiltAt=$_builtAt' \
	-X 'github.com/OpenListTeam/OpenList/internal/conf.GoVersion=$_goVersion' \
	-X 'github.com/OpenListTeam/OpenList/internal/conf.GitAuthor=$_gitAuthor' \
	-X 'github.com/OpenListTeam/OpenList/internal/conf.GitCommit=$_gitCommit' \
	-X 'github.com/OpenListTeam/OpenList/internal/conf.Version=$TERMUX_PKG_VERSION' \
	-X 'github.com/OpenListTeam/OpenList/internal/conf.WebVersion=$_OPENLIST_WEB_VERSION' \
	"
	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags" -tags=jsoniter
}

termux_step_make_install() {
	install -Dm700 ./"${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}"/bin

	# Provide a symlink from openliat to alist
	ln -sfr "$TERMUX_PREFIX"/bin/openlist "$TERMUX_PREFIX"/bin/alist

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/openlist.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_openlist"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/openlist.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		echo
		echo "********"
		echo "Starting from version 4.0, Alist has been replaced by OpenList. To ensure"
		echo "compatibility, a symbolic link from openlist to alist currently exists."
		echo "It may be removed in the future. Please migrate to OpenList accordingly."
		echo "********"
		echo

		openlist completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/openlist.bash
		openlist completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_openlist
		openlist completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/openlist.fish
	EOF
}
