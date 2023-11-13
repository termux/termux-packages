TERMUX_PKG_HOMEPAGE=https://github.com/nxtrace/Ntrace-V1
TERMUX_PKG_DESCRIPTION="An open source visual routing tool that pursues light weight"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.4.2"
TERMUX_PKG_SRCURL=https://github.com/nxtrace/Ntrace-V1/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ff77077a9b5fdb443f6092dfdebf9b972fdea2ac5204e1f70a87eed4e46ea0c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o nexttrace
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin nexttrace
}
