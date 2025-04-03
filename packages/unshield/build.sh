TERMUX_PKG_HOMEPAGE=https://github.com/twogood/unshield
TERMUX_PKG_DESCRIPTION="Tool and library to extract CAB files from InstallShield installers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.1"
TERMUX_PKG_SRCURL=https://github.com/twogood/unshield/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3f477d177e5ab805d41e5d06bb8cc42540769dd937ddc78e2e07f9f853034d66
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, openssl, openssh, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
