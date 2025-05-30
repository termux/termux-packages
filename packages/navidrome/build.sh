TERMUX_PKG_HOMEPAGE=https://www.navidrome.org/
TERMUX_PKG_DESCRIPTION="🎧☁️ Modern Music Server and Streamer compatible with Subsonic/Airsonic"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.56.1"
TERMUX_PKG_SRCURL=https://github.com/navidrome/navidrome/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da93448b008f8611f1e1c203285361b5c05ab429253495341cc0bf08a5c93359
TERMUX_PKG_DEPENDS="taglib, ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	rm -f Makefile

	termux_setup_golang
	termux_setup_nodejs

	local GO_VERSION=$(grep "^go " $TERMUX_PKG_SRCDIR/go.mod | cut -f 2 -d ' ')
	local NODE_VERSION=$(. $TERMUX_SCRIPTDIR/packages/golang/build.sh; echo $TERMUX_PKG_VERSION)
	local GIT_SHA=$(git ls-remote https://github.com/navidrome/navidrome refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	export GIT_TAG="v$TERMUX_PKG_VERSION"
	# Build frontend
	cd $TERMUX_PKG_SRCDIR/ui
	npm ci && npm run build

	# Build backend
	cd $TERMUX_PKG_SRCDIR
	go build -o navidrome -ldflags="-X github.com/navidrome/navidrome/consts.gitSha=$GIT_SHA -X github.com/navidrome/navidrome/consts.gitTag=$GIT_TAG-SNAPSHOT" -tags=netgo
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin ${TERMUX_PKG_SRCDIR}/navidrome

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/navidrome.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_navidrome"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/navidrome.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		navidrome completion bash -n > ${TERMUX_PREFIX}/share/bash-completion/completions/navidrome.bash
		navidrome completion zsh -n > ${TERMUX_PREFIX}/share/zsh/site-functions/_navidrome
		navidrome completion fish -n > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/navidrome.fish
	EOF
}
