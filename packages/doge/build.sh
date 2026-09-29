TERMUX_PKG_HOMEPAGE=https://github.com/Dj-Codeman/dog_community
TERMUX_PKG_DESCRIPTION="A command-line DNS client"
TERMUX_PKG_LICENSE="EUPL-1.2"
TERMUX_PKG_LICENSE_FILE="LICENCE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.9
TERMUX_PKG_SRCURL=https://github.com/Dj-Codeman/dog_community/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=21d459f1f88d6a1e001a747b84782f180c01de8f3c39f3a1389c352b2f2edc88
TERMUX_PKG_REPLACES="dog"
TERMUX_PKG_DEPENDS="openssl, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	rm $TERMUX_PKG_SRCDIR/makefile
}
