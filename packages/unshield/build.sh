TERMUX_PKG_HOMEPAGE=https://github.com/twogood/unshield
TERMUX_PKG_DESCRIPTION="Tool and library to extract CAB files from InstallShield installers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL=https://github.com/twogood/unshield/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c3974a906ddbdc2805b3f6b36cb01f11fe0ede7a7702514acb2ad4a66ec7ae62
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, openssl, openssh, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
