TERMUX_PKG_HOMEPAGE=https://maunium.net/go/gomuks/
TERMUX_PKG_DESCRIPTION="A terminal Matrix client written in Go"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tulir/gomuks/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0710a63cc3ec9a4f525510497ba64aa94170498eb536411d089871f336d99ab4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libolm, resolv-conf"
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
