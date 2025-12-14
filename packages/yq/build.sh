TERMUX_PKG_HOMEPAGE=https://mikefarah.gitbook.io/yq/
TERMUX_PKG_DESCRIPTION="A lightweight and portable command-line YAML, JSON and XML processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.50.1"
TERMUX_PKG_SRCURL=https://github.com/mikefarah/yq/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ec55f107fbfe1d8226c1d4d74def734672f9aa58165029819ddfb771339e53a1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_REPLACES="xpup"

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin yq
}
