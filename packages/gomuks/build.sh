TERMUX_PKG_HOMEPAGE=https://maunium.net/go/gomuks/
TERMUX_PKG_DESCRIPTION="A terminal Matrix client written in Go"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_SRCURL=https://github.com/tulir/gomuks/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e5212c416a84a5e8f46ab6b36cf9cfec36918930dbf7a155cce00570887600f7
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
