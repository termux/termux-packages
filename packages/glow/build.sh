TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/glow
TERMUX_PKG_DESCRIPTION="Render markdown on the CLI, with pizzazz!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.2"
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/glow/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1b933139da1d08647bf5b3f112cab9548fdc2b40c056c7fa3d84d8706de5265a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SUGGESTS=git

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/charmbracelet"

	go get -v
	go build
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
	install -Dm700 glow "$TERMUX_PREFIX/bin/glow"
}
