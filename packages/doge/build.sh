TERMUX_PKG_HOMEPAGE=https://github.com/Dj-Codeman/dog_community
TERMUX_PKG_DESCRIPTION="A command-line DNS client"
TERMUX_PKG_LICENSE="EUPL-1.2"
TERMUX_PKG_LICENSE_FILE="LICENCE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/Dj-Codeman/dog_community/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4ad82572271bc4601ac3b9b5f68be83f2659bdb5370c1b19297ecf3bd964f957
TERMUX_PKG_REPLACES="dog"
TERMUX_PKG_DEPENDS="openssl, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/makefile
}
