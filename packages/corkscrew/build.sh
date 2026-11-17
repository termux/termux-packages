TERMUX_PKG_HOMEPAGE="https://github.com/patpadgett/corkscrew"
TERMUX_PKG_DESCRIPTION="A tool for tunneling SSH through HTTP proxies"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_SRCURL=https://github.com/patpadgett/corkscrew/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f9c62466b4cbb13e3384eda2e00eb5e793acf82a5c2980d81a334151d202255
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="openssh"

termux_step_pre_configure() {
	autoreconf -fi
}
