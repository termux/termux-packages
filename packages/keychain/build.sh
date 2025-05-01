TERMUX_PKG_HOMEPAGE=https://www.funtoo.org/Keychain
TERMUX_PKG_DESCRIPTION="keychain ssh-agent front-end"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.1"
TERMUX_PKG_SRCURL=https://github.com/funtoo/keychain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=49e7bec7495cf79300a23ad13fbdd7c2083f823c7dac2c1333bd70e8bfd83d8d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="dash, gnupg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 keychain "${TERMUX_PREFIX}"/bin/keychain
	install -Dm600 keychain.1 "${TERMUX_PREFIX}"/share/man/man1/keychain.1
}
