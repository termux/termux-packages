TERMUX_PKG_HOMEPAGE=https://artalk.js.org/
TERMUX_PKG_DESCRIPTION="A self-hosted comment system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Moraxyc <termux@qaq.li>"
TERMUX_PKG_VERSION="2.9.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(
	"https://github.com/ArtalkJS/Artalk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/ArtalkJS/Artalk/releases/download/v${TERMUX_PKG_VERSION}/artalk_ui.tar.gz"
)
TERMUX_PKG_SHA256=(
	edb1f85fb84e103d9a6bfda25191b174df22b354c6d9d3dedb154c2fbbddc2ee
	724282e2512b295749b89fa91b2b26311f7a6bd2e4ac2627581e23e953cff0e6
)
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	mv artalk_ui/* public
}

termux_step_make() {
	termux_setup_golang
	local _gitCommit ldflags

	export CGO_ENABLED=1
	_gitCommit=$(git ls-remote https://github.com/ArtalkJS/Artalk refs/tags/v$TERMUX_PKG_VERSION | head -c 7)

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
