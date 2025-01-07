TERMUX_PKG_HOMEPAGE=https://github.com/orhun/pkgtop
TERMUX_PKG_DESCRIPTION="Interactive package manager and resource monitor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_SRCURL=https://github.com/orhun/pkgtop/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3d8f1cd812fd2243fbf749ab03201bb86b9967cefd5d58cea456cdfcccfd416e
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
