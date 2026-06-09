TERMUX_PKG_HOMEPAGE=https://github.com/n0-computer/sendme
TERMUX_PKG_DESCRIPTION="A tool to send files and directories, based on iroh"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE-APACHE
LICENSE-MIT
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.35.0"
TERMUX_PKG_SRCURL="https://github.com/n0-computer/sendme/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=57fb54bee5c279f50e3c2ee5ea4eb568cec8273e2bf4a4d46d92d693cd4a28ac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
