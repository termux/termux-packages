TERMUX_PKG_HOMEPAGE=https://github.com/orhun/pkgtop
TERMUX_PKG_DESCRIPTION="Interactive package manager and resource monitor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.1
TERMUX_PKG_SRCURL=https://github.com/orhun/pkgtop/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db32c40858033fccb0f1d27c409dc47447199ab2635bf25e82284f5619b0e113
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o pkgtop ./cmd
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin pkgtop
}
