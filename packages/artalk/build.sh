TERMUX_PKG_HOMEPAGE=https://artalk.js.org/
TERMUX_PKG_DESCRIPTION="A self-hosted comment system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Moraxyc <termux@qaq.li>"
TERMUX_PKG_VERSION=2.8.7
TERMUX_PKG_SRCURL=(https://github.com/ArtalkJS/Artalk/archive/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/ArtalkJS/Artalk/releases/download/v${TERMUX_PKG_VERSION}/artalk_ui.tar.gz)
TERMUX_PKG_SHA256=(62e6fb2dbd8fa5c93a639b83874dafbe1ea3893477760a9e764a8085cdbc94e1
                   619b2d823cfaab7d9e98a4520b9f3f4d1f0e61d4aaf6022b13fb12f1830540ba)
TERMUX_PKG_BUILD_IN_SRC=true
# termux_pkg_upgrade_version couldn't check multiple versions now.
TERMUX_PKG_AUTO_UPDATE=false

termux_step_post_get_source() {
	mv artalk_ui/* public
}

termux_step_make() {
	termux_setup_golang

	local ldflags
	local _gitCommit=$(git ls-remote https://github.com/ArtalkJS/Artalk refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	export CGO_ENABLED=1

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
