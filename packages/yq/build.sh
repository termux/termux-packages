TERMUX_PKG_HOMEPAGE=https://mikefarah.gitbook.io/yq/
TERMUX_PKG_DESCRIPTION="A lightweight and portable command-line YAML, JSON and XML processor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.33.1"
TERMUX_PKG_SRCURL=https://github.com/mikefarah/yq/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c38b8210fb5a80ac88314fa346ea31f3dc9324cae9fe93cb334cacf909e09bc3
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ENABLE_CLANG16_PORTING=false

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin yq
}
