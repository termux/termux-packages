TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.43.0"
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

_RELEASE_URL=https://github.com/v2fly/v2ray-core/releases/download/v$TERMUX_PKG_VERSION/v2ray-linux-64.zip
_RELEASE_SHA256=bd6552a5cdad3bd0b8b932ccf0f1ba228dd761ae43c19367a15596db1d24d7fe

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(termux_github_api_get_tag)"
	(( ${#latest_tag} )) || {
		printf '%s\n' \
		'WARN: Auto update failure!' \
		"latest_tag=${latest_tag}"
	return
	} >&2

	latest_tag="${latest_tag#v}"

	if [[ "${latest_tag}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_tag}."
		return
	fi

	local tmpdir sha
	tmpdir="$(mktemp -d)"
	curl -sLo "${tmpdir}/tmpfile" "https://github.com/v2fly/v2ray-core/releases/download/v$latest_tag/v2ray-linux-64.zip"
	sha="$(sha256sum "${tmpdir}/tmpfile" | cut -d ' ' -f 1)"

	sed \
		-e "s|^_RELEASE_SHA256=.*|_RELEASE_SHA256=${sha}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	printf '%s\n' 'INFO: Generated checksums:' "${sha}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R

	termux_download $_RELEASE_URL \
		$TERMUX_PKG_CACHEDIR/v2ray-linux-64-$TERMUX_PKG_VERSION.zip \
		$_RELEASE_SHA256
	mkdir -p $TERMUX_PKG_SRCDIR/v2ray-linux-64
	unzip -d $TERMUX_PKG_SRCDIR/v2ray-linux-64 $TERMUX_PKG_CACHEDIR/v2ray-linux-64-$TERMUX_PKG_VERSION.zip

	local d
	for d in go/pkg/mod/github.com/adrg/xdg*/; do
		sed 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
			$TERMUX_PKG_BUILDER_DIR/0001-fix-config-paths.diff \
			| patch -p1 -d ${d}
	done
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray $TERMUX_PKG_SRCDIR/v2ray-linux-64/geoip.dat
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray $TERMUX_PKG_SRCDIR/v2ray-linux-64/geosite.dat
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray $TERMUX_PKG_SRCDIR/v2ray-linux-64/geoip-only-cn-private.dat
}
