TERMUX_PKG_HOMEPAGE=https://tinygo.org
TERMUX_PKG_DESCRIPTION="Go compiler for small places."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.22.0
TERMUX_PKG_SRCURL=https://github.com/tinygo-org/tinygo/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d8456c82682d1ece1285887573eb7c421a47e87ffe59ed76ecd87af6de3ba886
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="golang,libllvm,cmake,ninja,build-essential,git"

termux_step_pre_configure() {
	termux_setup_golang
	
	export CGO_ENABLED=1
	go build
}
