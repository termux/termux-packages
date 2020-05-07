TERMUX_PKG_HOMEPAGE=https://www.funtoo.org/Keychain
TERMUX_PKG_DESCRIPTION="keychain ssh-agent front-end"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.8.5
TERMUX_PKG_SRCURL=https://github.com/funtoo/keychain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dcce703e5001211c8ebc0528f45b523f84d2bceeb240600795b4d80cb8475a0b
TERMUX_PKG_DEPENDS="gnupg"
#TERMUX_PKG_BUILD_IN_SRC=true


termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/
        install -m 755 keychain "${TERMUX_PREFIX}"/bin/keychain
}
