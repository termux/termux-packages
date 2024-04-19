TERMUX_PKG_HOMEPAGE=https://github.com/kubecolor/kubecolor
TERMUX_PKG_DESCRIPTION="Colorize your kubectl output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Kalle Fagerberg @applejag"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_SRCURL=https://github.com/kubecolor/kubecolor/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=47a3d29ec38fd92198ee6e3741cf32ff8b0f2b2eb5b1ce9719f8cfc2bf3a01ff
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
