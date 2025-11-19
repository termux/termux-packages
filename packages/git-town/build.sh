TERMUX_PKG_HOMEPAGE="https://www.git-town.com"
TERMUX_PKG_DESCRIPTION="Git branches made easy"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="22.2.0"
TERMUX_PKG_SRCURL="https://github.com/git-town/git-town/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=93d9b599d14817eda971703aef3c7df409b051611ceda014ce175fbe42bf1d69
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go get -v
	go build
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"

	( # borrowed from packages/glow
	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completions  zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	go run . completions bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	go run . completions fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm755 "$TERMUX_PKG_SRCDIR/git-town" -t "$TERMUX_PREFIX/bin"
	)
}
