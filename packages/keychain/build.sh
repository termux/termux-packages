TERMUX_PKG_HOMEPAGE=https://kernel-seeds.org/projects/keychain/
TERMUX_PKG_DESCRIPTION="Keychain manager for ssh-agent and gpg-agent"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.2"
TERMUX_PKG_SRCURL="https://github.com/danielrobbins/keychain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=48ccbf24d7775b96f1730b3a1a95cd06bb73f267f126b9da36ccfba0e8c02f2f
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_SUGGESTS="gnupg, openssh"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+(?!.beta)'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 keychain.pyz "${TERMUX_PREFIX}"/bin/keychain
}
