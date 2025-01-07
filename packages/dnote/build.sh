TERMUX_PKG_HOMEPAGE=https://www.getdnote.com/
TERMUX_PKG_DESCRIPTION="A simple command line notebook for programmers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION="1:0.15.1"
TERMUX_PKG_SRCURL=https://github.com/dnote/dnote/archive/refs/tags/cli-v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=257d5f2374507b2790b31a314d7434bfe84b3178724ef73fdc4775c391220f93
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS=dnote-client
TERMUX_PKG_REPLACES=dnote-client

termux_step_pre_configure() {
	termux_setup_golang
	go mod download
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"
	go build -o dnote -ldflags "-X main.versionTag=${TERMUX_PKG_VERSION:2}" -tags fts5 pkg/cli/main.go
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/dnote $TERMUX_PREFIX/bin/dnote
	install -Dm600 "$TERMUX_PKG_SRCDIR"/pkg/cli/dnote-completion.bash \
		"$TERMUX_PREFIX"/share/bash-completion/completions/dnote
	install -Dm600 "$TERMUX_PKG_SRCDIR"/pkg/cli/dnote-completion.zsh \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_dnote
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/licenses/GPLv3.txt"
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	if grep -qP "^cli-v${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a CLI release($tag)"
	fi
}
