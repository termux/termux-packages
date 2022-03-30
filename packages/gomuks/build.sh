TERMUX_PKG_HOMEPAGE=https://maunium.net/go/gomuks/
TERMUX_PKG_DESCRIPTION="A terminal Matrix client written in Go"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.4
TERMUX_PKG_SRCURL=https://github.com/tulir/gomuks/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b40e2fdc14e8300d0b95afd032654e588d2390c56d4a9abd46ebc9831033fdd8
TERMUX_PKG_DEPENDS="libolm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin gomuks
}
