TERMUX_PKG_HOMEPAGE=https://mikefarah.gitbook.io/yq/
TERMUX_PKG_DESCRIPTION="A lightweight and portable command-line YAML, JSON and XML processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.30.4"
TERMUX_PKG_SRCURL=https://github.com/mikefarah/yq/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d46e4f5176d6115107909623bd89ceb7ae991acc0980112ba9b0159811229c0c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin yq
}
