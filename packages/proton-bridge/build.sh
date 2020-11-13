TERMUX_PKG_HOMEPAGE=https://github.com/ProtonMail/proton-bridge
TERMUX_PKG_DESCRIPTION="ProtonMail Bridge application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ProtonMail/proton-bridge.git
TERMUX_PKG_GIT_BRANCH=br-$TERMUX_PKG_VERSION 
TERMUX_PKG_MAINTAINER="Radomír Polách <rp@t4d.cz>"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	export BUILDDIR=$TERMUX_PREFIX/bin
	cd $TERMUX_PKG_SRCDIR
	make build-nogui
	install -Dm700 Desktop-Bridge "$TERMUX_PREFIX"/bin/proton-bridge
}
