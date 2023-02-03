TERMUX_PKG_HOMEPAGE=https://github.com/Depau/ttyc
TERMUX_PKG_DESCRIPTION="ttyd protocol client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Depau/ttyc/archive/refs/tags/ttyc-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=375e2b27335ed3db13aee6d4525548148b8579cdbe34ed4d971d4e3cdff0f173
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy 
}

termux_step_make() {
	go build -v ./cmd/ttyc
	cd $TERMUX_PKG_SRCDIR/cmd/ttyc
	go build -o ttyc
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin cmd/ttyc/ttyc
}
