TERMUX_PKG_HOMEPAGE=https://github.com/42wim/matterircd
TERMUX_PKG_DESCRIPTION="Connect to your mattermost or slack using your IRC-client of choice"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.33.0"
TERMUX_PKG_SRCURL=https://github.com/42wim/matterircd/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f8bf3e0908b1e67cfef931c8fadf9631974506ed3f78501b34e58879f1448e6
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
