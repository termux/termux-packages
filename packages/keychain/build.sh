TERMUX_PKG_HOMEPAGE=https://www.funtoo.org/Keychain
TERMUX_PKG_DESCRIPTION="keychain ssh-agent front-end"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.0"
TERMUX_PKG_SRCURL=https://github.com/funtoo/keychain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=834e02ba99c20e93aaceba0ec510bd16f2cc0e6e1af56c039d3e57128b52b5ad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="dash, gnupg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 keychain "${TERMUX_PREFIX}"/bin/keychain
	install -Dm600 keychain.1 "${TERMUX_PREFIX}"/share/man/man1/keychain.1
}
