TERMUX_PKG_HOMEPAGE=https://github.com/kubecolor/kubecolor
TERMUX_PKG_DESCRIPTION="Colorize your kubectl output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Kalle Fagerberg @applejag"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL=https://github.com/kubecolor/kubecolor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99b2126c4d33664220ee8270def853d668ebdb1418b1eeaf93b1ab7d8799561c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kubectl"

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go build -o kubecolor -ldflags "-X main.Version=v${TERMUX_PKG_VERSION}"
}

termux_step_make_install() {
	install -Dm700 kubecolor "$TERMUX_PREFIX/bin"
}
