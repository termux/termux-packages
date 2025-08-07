TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/crush
TERMUX_PKG_DESCRIPTION="The glamourous AI coding agent for your favourite terminal"
TERMUX_PKG_LICENSE="FSL-1.1-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.2"
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/crush/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77706263a32739967fbfa2ad12d0d6dcce02ca59e28e2ab1f847326a63e7a6ca
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SUGGESTS=git

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/charmbracelet"

	go get -v
	go build -ldflags "-s -w -X github.com/charmbracelet/crush/internal/version.Version=${TERMUX_PKG_VERSION}"
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"

	# borrowed from packages/gh
	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run .             man > "${TERMUX_PREFIX}/share/man/man1/${TERMUX_PKG_NAME}.1"
	go run . completion  zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm700 crush "$TERMUX_PREFIX/bin/crush"
}
