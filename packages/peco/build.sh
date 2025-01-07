TERMUX_PKG_HOMEPAGE=https://github.com/peco/peco
TERMUX_PKG_DESCRIPTION="Simplistic interactive filtering tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.11"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/peco/peco/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8e32c8af533e03795f27feb4ee134960611d2fc0266528b1c512a6f1f065b164
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"/cmd/peco
	go build -o peco
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/cmd/peco/peco
}
