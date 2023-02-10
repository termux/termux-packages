TERMUX_PKG_HOMEPAGE=https://github.com/OwO-Network/nexttrace-enhanced
TERMUX_PKG_DESCRIPTION="An open source visual routing tool that pursues light weight"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1-beta.5"
TERMUX_PKG_SRCURL=https://github.com/OwO-Network/nexttrace-enhanced/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88dc44a18edee96fe61290003037e23d2d7229d6c365e8f9182bf355102caeac
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
