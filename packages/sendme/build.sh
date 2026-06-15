TERMUX_PKG_HOMEPAGE=https://github.com/n0-computer/sendme
TERMUX_PKG_DESCRIPTION="A tool to send files and directories, based on iroh"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE-APACHE
LICENSE-MIT
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.36.0"
TERMUX_PKG_SRCURL="https://github.com/n0-computer/sendme/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=69897a9785c5b87c769417f77de8bff6e34e5391eed3d2df5d270599daf485ad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
