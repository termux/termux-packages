TERMUX_PKG_HOMEPAGE=https://github.com/twogood/unshield
TERMUX_PKG_DESCRIPTION="Tool and library to extract CAB files from InstallShield installers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/twogood/unshield/archive/1.4.3.tar.gz
TERMUX_PKG_SHA256=aa8c978dc0eb1158d266eaddcd1852d6d71620ddfc82807fe4bf2e19022b7bab
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, openssh, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
