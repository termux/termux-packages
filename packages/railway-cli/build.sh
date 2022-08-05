TERMUX_PKG_HOMEPAGE=https://railway.app
TERMUX_PKG_DESCRIPTION="This is the command line interface for Railway"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.7"
TERMUX_PKG_SRCURL=https://github.com/railwayapp/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b12e279935fc7a2f37caa558d507bb5746fd05e5afba23a66c8a8a3f661ddb9
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go build -ldflags="-s -w -X github.com/railwayapp/cli/constants.Version=${TERMUX_PKG_VERSION}" -o bin/railway
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/railway
}
