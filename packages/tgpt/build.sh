TERMUX_PKG_HOMEPAGE=https://github.com/aandrew-me/tgpt
TERMUX_PKG_DESCRIPTION="AI Chatbots in terminal without needing API keys"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.0"
TERMUX_PKG_SRCURL=https://github.com/aandrew-me/tgpt/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0e312176908d581eeb7f0df8fcd0524a4aa4702029d50f553f0f75d6c15bc0d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 tgpt "$TERMUX_PREFIX"/bin/tgpt
}
