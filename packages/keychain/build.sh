TERMUX_PKG_HOMEPAGE=https://kernel-seeds.org/projects/keychain/
TERMUX_PKG_DESCRIPTION="Keychain manager for ssh-agent and gpg-agent"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.7"
TERMUX_PKG_SRCURL="https://github.com/danielrobbins/keychain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=573002c4da81efa27908d197fec7121e5bb7b0018605aa34f345c1cbf7486843
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_SUGGESTS="gnupg, openssh"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+(?!.beta)'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 keychain.pyz "${TERMUX_PREFIX}"/bin/keychain
}
