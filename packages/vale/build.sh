TERMUX_PKG_HOMEPAGE=https://vale.sh
TERMUX_PKG_DESCRIPTION="A syntax-aware linter for prose built with speed and extensibility in mind"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.21.2"
TERMUX_PKG_SRCURL=https://github.com/errata-ai/vale/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0766da43f7b402f2850b87b1aec8f13174d122c5e364df13b8961cf0deb2bac
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
