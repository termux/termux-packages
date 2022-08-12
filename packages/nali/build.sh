TERMUX_PKG_HOMEPAGE=https://github.com/zu1k/nali
TERMUX_PKG_DESCRIPTION="An offline tool for querying IP geographic information and CDN provider"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_SRCURL=https://github.com/zu1k/nali/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd3dabda33a381d0072f9c657098c3c01c793195bc6326015b36c8a168943f1c
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
