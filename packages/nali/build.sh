TERMUX_PKG_HOMEPAGE=https://github.com/zu1k/nali
TERMUX_PKG_DESCRIPTION="An offline tool for querying IP geographic information and CDN provider"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.1"
TERMUX_PKG_SRCURL=https://github.com/zu1k/nali/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=443bb5d938c2abafd74a0e1d932eb5966b0f6d2aae7a784e4899c152efb818a1
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
	install -Dm700 -t "${TERMUX_PREFIX}"/bin nali
}
