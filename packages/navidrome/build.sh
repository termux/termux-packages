TERMUX_PKG_HOMEPAGE=https://www.navidrome.org/
TERMUX_PKG_DESCRIPTION="Modern Music Server and Streamer compatible with Subsonic/Airsonic"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.59.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/navidrome/navidrome/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b2a61c975029e59981cc2b443d9382ef92526325dcf26f82c9dd4b004454736d
TERMUX_PKG_DEPENDS="taglib, ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	rm -f Makefile

	termux_setup_golang
	termux_setup_nodejs

	local GIT_SHA
	GIT_SHA="$(git ls-remote https://github.com/navidrome/navidrome "refs/tags/v$TERMUX_PKG_VERSION" | head -c 7)"
	export GIT_TAG="v$TERMUX_PKG_VERSION"

	# Build backend
	cd $TERMUX_PKG_SRCDIR
	export CGO_ENABLED=1 CGO_CFLAGS_ALLOW="--define-prefix"
	go build -v -ldflags="
	-X github.com/navidrome/navidrome/consts.gitSha=$GIT_SHA \
	-X github.com/navidrome/navidrome/consts.gitTag=$GIT_TAG-SNAPSHOT" \
	-tags=netgo \
	-o navidrome

	# Build frontend
	cd $TERMUX_PKG_SRCDIR/ui
	npm ci && npm run build

}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}/navidrome"

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
