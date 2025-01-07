TERMUX_PKG_HOMEPAGE=https://github.com/ericchiang/pup
TERMUX_PKG_DESCRIPTION="command line tool for processing HTML"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/ericchiang/pup/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init github.com/ericchiang/pup || :
	go mod tidy
	go mod vendor

	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin pup
}
