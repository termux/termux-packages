TERMUX_PKG_HOMEPAGE=https://github.com/polyzium/termbot
TERMUX_PKG_DESCRIPTION="A fully fledged terminal emulator in a Discord chat"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2022.09.03"
TERMUX_PKG_SRCURL=https://github.com/polyzium/termbot.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GIT_BRANCH=master

termux_step_make() {
	termux_setup_golang

	go build -o termbot
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin termbot
}
