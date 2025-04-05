TERMUX_PKG_HOMEPAGE=https://github.com/twogood/unshield
TERMUX_PKG_DESCRIPTION="Tool and library to extract CAB files from InstallShield installers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.2"
TERMUX_PKG_SRCURL=https://github.com/twogood/unshield/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a937ef596ad94d16e7ed2c8553ad7be305798dcdcfd65ae60210b1e54ab51a2f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, openssl, openssh, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
