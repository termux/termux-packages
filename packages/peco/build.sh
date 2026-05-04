TERMUX_PKG_HOMEPAGE=https://github.com/peco/peco
TERMUX_PKG_DESCRIPTION="Simplistic interactive filtering tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL=https://github.com/peco/peco/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=480ba339c5b15ebb9eada276d5e25315ee5c36e878d86dcfc1ea17f54a27197a
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
