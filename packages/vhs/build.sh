TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/vhs
TERMUX_PKG_DESCRIPTION="Your CLI home video recorder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/charmbracelet/vhs
TERMUX_PKG_GIT_BRANCH="v$TERMUX_PKG_VERSION"
TERMUX_PKG_DEPENDS="ttyd, ffmpeg"
TERMUX_PKG_SUGGESTS="chromium"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_configure(){
	termux_setup_golang
}

termux_step_make(){
	# FIX: chromium path
	sed -i "s|path, _ := launcher.LookPath()|path := \"${TERMUX_PREFIX}/bin/chromium-browser\"|" "$TERMUX_PKG_SRCDIR/vhs.go"

	go build -o vhs -ldflags "-s -w \
	-X main.Version=v${TERMUX_PKG_VERSION} \
	-X main.CommitSHA=$(git rev-parse HEAD) \
	-X main.CommitDate=$(git show --no-patch --format=%cd --date=format:%Y-%m-%d)"
}

termux_step_make_install(){
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run .             man > "${TERMUX_PREFIX}/share/man/man1/${TERMUX_PKG_NAME}.1"
	go run . completion  zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm755 -t "${TERMUX_PREFIX}"/bin vhs
}
