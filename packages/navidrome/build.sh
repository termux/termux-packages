TERMUX_PKG_HOMEPAGE=https://www.navidrome.org/
TERMUX_PKG_DESCRIPTION="Modern Music Server and Streamer compatible with Subsonic/Airsonic"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="2096779623 <admin@utermux.dev>"
TERMUX_PKG_VERSION="0.60.3"
TERMUX_PKG_SRCURL="https://github.com/navidrome/navidrome/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=afb07417b2d38ee6d757bc4e1ea1ff635f2666e149c44a883560a5bcda2d8556
TERMUX_PKG_DEPENDS="taglib, ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_CONFFILES="etc/navidrome/navidrome.toml"

termux_step_make() {
	rm -f Makefile

	termux_setup_golang
	termux_setup_nodejs

	local GIT_SHA
	GIT_SHA="$(git ls-remote https://github.com/navidrome/navidrome "refs/tags/v$TERMUX_PKG_VERSION" | head -c 7)"
	export GIT_TAG="v$TERMUX_PKG_VERSION"

	# Build frontend
	pushd "$TERMUX_PKG_SRCDIR/ui"
	npm ci && npm run build
	popd

	# Build backend
	cd "$TERMUX_PKG_SRCDIR"
	export CGO_ENABLED=1 CGO_CFLAGS_ALLOW="--define-prefix"
	go build -v -ldflags="
	-X github.com/navidrome/navidrome/consts.gitSha=$GIT_SHA \
	-X github.com/navidrome/navidrome/consts.gitTag=$GIT_TAG-SNAPSHOT" \
	-tags=netgo \
	-o navidrome
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}/navidrome"

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/navidrome.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_navidrome"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/navidrome.fish"

	install -Dm644 -t "${TERMUX_PREFIX}/etc/navidrome" release/linux/navidrome.toml

	install -Dm644 /dev/null "${TERMUX_PREFIX}/opt/navidrome/music/.placeholder"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		navidrome completion bash -n > ${TERMUX_PREFIX}/share/bash-completion/completions/navidrome.bash
		navidrome completion zsh -n > ${TERMUX_PREFIX}/share/zsh/site-functions/_navidrome
		navidrome completion fish -n > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/navidrome.fish
	EOF
}
