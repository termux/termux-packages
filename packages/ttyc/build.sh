TERMUX_PKG_HOMEPAGE=https://github.com/Depau/ttyc
TERMUX_PKG_DESCRIPTION="ttyd protocol client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3"
TERMUX_PKG_SRCURL=https://github.com/Depau/ttyc/archive/refs/tags/wistty-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c2240bff19219e5770dbe6e9ed1e5b96916bee4a5b2c5e7b636c5495724c2881
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_REVISION=1

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
