TERMUX_PKG_HOMEPAGE=https://github.com/42wim/matterircd
TERMUX_PKG_DESCRIPTION="Connect to your mattermost or slack using your IRC-client of choice"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/42wim/matterircd/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2cbd397430e757231caef4563c21c2c0337a9e54f4028d4e3e8471ecae36979f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/matterircd
}
