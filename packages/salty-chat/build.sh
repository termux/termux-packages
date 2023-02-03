TERMUX_PKG_HOMEPAGE=https://salty.im/
TERMUX_PKG_DESCRIPTION="A secure, easy, self-hosted messaging"
TERMUX_PKG_LICENSE="MIT, WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.22
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.mills.io/saltyim/saltyim/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6313a4b3b0b53e899f4612701dbf4d4abd212b51f48a69461309d136338a405d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy 
}


