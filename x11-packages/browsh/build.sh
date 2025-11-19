TERMUX_PKG_HOMEPAGE=http://www.brow.sh/
TERMUX_PKG_DESCRIPTION="A fully-modern text-based browser, rendering to TTY and browsers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_SRCURL=https://github.com/browsh-org/browsh/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=88462530dbfac4e17c8f8ba560802d21042d90236043e11461a1cfbf458380ca
TERMUX_PKG_DEPENDS="firefox"
TERMUX_PKG_ANTI_BUILD_DEPENDS="firefox"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

_BROWSH_EXTENSION_URL="https://github.com/browsh-org/browsh/releases/download/v$TERMUX_PKG_VERSION/browsh-$TERMUX_PKG_VERSION.xpi"
_BROWSH_EXTENSION_SHA256=c0b72d7c61c30a0cb79cc1bf9dcf3cdaa3631ce029f1578e65c116243ed04e16

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(termux_github_api_get_tag "https://github.com/browsh-org/browsh" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
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
	curl -sLo "${tmpdir}/tmpfile" "https://github.com/browsh-org/browsh/releases/download/v$latest_tag/browsh-$latest_tag.xpi"
	local sha="$(sha256sum "${tmpdir}/src" | cut -d ' ' -f 1)"

	sed \
		-e "s|^_BROWSH_EXTENSION_SHA256=.*|_BROWSH_EXTENSION_SHA256=${sha}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	printf '%s\n' 'INFO: Generated checksums:' "${sha}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_post_get_source() {
	termux_download \
		"$_BROWSH_EXTENSION_URL" \
		"$TERMUX_PKG_CACHEDIR/$(basename $_BROWSH_EXTENSION_URL)" \
		$_BROWSH_EXTENSION_SHA256

	cp -f "$TERMUX_PKG_CACHEDIR/$(basename $_BROWSH_EXTENSION_URL)" \
		"$TERMUX_PKG_SRCDIR"/interfacer/src/browsh/browsh.xpi
}

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR/interfacer
	go build -x -modcacherw -o ./bin/browsh ./cmd/browsh
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./interfacer/bin/browsh
}
