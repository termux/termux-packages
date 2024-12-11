TERMUX_PKG_HOMEPAGE=https://github.com/twogood/unshield
TERMUX_PKG_DESCRIPTION="Tool and library to extract CAB files from InstallShield installers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/twogood/unshield/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=34cd97ff1e6f764436d71676e3d6842dc7bd8e2dd5014068da5c560fe4661f60
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, openssl, openssh, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
