TERMUX_PKG_HOMEPAGE=https://github.com/42wim/matterircd
TERMUX_PKG_DESCRIPTION="Connect to your mattermost or slack using your IRC-client of choice"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.34.0"
TERMUX_PKG_SRCURL=https://github.com/42wim/matterircd/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad3fece60aa45229adf31d1e5a0a6b430911dc9aa90a2020cb78b595b4a3aa44
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
