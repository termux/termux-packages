TERMUX_PKG_HOMEPAGE=https://kernel-seeds.org/projects/keychain/
TERMUX_PKG_DESCRIPTION="Keychain manager for ssh-agent and gpg-agent"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/danielrobbins/keychain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=589cf55ae5c4b65af1d977d705beb319006efca5bcdda8352b8558d0dcff5a84
TERMUX_PKG_DEPENDS="dash, gnupg"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+(?!.beta)'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 keychain "${TERMUX_PREFIX}"/bin/keychain
	install -Dm600 keychain.1 "${TERMUX_PREFIX}"/share/man/man1/keychain.1
}
