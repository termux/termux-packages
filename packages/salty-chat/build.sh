TERMUX_PKG_HOMEPAGE=https://salty.im/
TERMUX_PKG_DESCRIPTION="A secure, easy, self-hosted messaging"
TERMUX_PKG_LICENSE="MIT, WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.22
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://git.mills.io/saltyim/saltyim/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fdc4dd8c0547f87f3c04022eb4558420eb07b136cc4de8b0d75b8b8cf47a0040
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
