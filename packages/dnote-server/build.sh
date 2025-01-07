TERMUX_PKG_HOMEPAGE=https://www.getdnote.com/
TERMUX_PKG_DESCRIPTION="This package contains the Dnote server. It comprises of the web interface, the web API, and the background jobs."
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/dnote/dnote/archive/refs/tags/server-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5326694dd4c1721e52b871cebc3b99f9172d5e27c8eb71234cdf529bdcd14eee
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS="postgresql"

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_golang

	go mod download

	# build assets for dnote-server:
	cd "$TERMUX_PKG_SRCDIR/pkg/server/assets"
	npm i
	./js/build.sh
	./styles/build.sh
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"

	# build binary
	moduleName="github.com/dnote/dnote"
	ldflags="-X '$moduleName/pkg/server/buildinfo.CSSFiles=main.css' -X '$moduleName/pkg/server/buildinfo.JSFiles=main.js' -X '$moduleName/pkg/server/buildinfo.Version=$TERMUX_PKG_VERSION' -X '$moduleName/pkg/server/buildinfo.Standalone=true'"

	go build -o dnote-server -ldflags "$ldflags" pkg/server/main.go
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/dnote-server $TERMUX_PREFIX/bin/dnote-server
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/licenses/AGPLv3.txt"
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	if grep -qP "^server-v${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a SERVER release($tag)"
	fi
}
