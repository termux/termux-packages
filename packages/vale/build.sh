TERMUX_PKG_HOMEPAGE=https://vale.sh
TERMUX_PKG_DESCRIPTION="A syntax-aware linter for prose built with speed and extensibility in mind"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.1"
TERMUX_PKG_SRCURL=https://github.com/errata-ai/vale/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77cc65eab69827f3a3b372b4edd1e1d11079e087768038441cc26976ebe9b48d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"/cmd/vale
	go build -o vale -ldflags="-s -w -X 'main.version=${TERMUX_PKG_VERSION}'"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/cmd/vale/vale
}
