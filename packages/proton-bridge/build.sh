TERMUX_PKG_HOMEPAGE=https://github.com/ProtonMail/proton-bridge
TERMUX_PKG_DESCRIPTION="ProtonMail Bridge application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.1.3
TERMUX_PKG_SRCURL=https://github.com/ProtonMail/proton-bridge.git
TERMUX_PKG_GIT_BRANCH=br-$TERMUX_PKG_VERSION
TERMUX_PKG_MAINTAINER="Radomír Polách <rp@t4d.cz>"
TERMUX_PKG_DEPENDS=libsecret
TERMUX_PKG_AUTO_UPDATE=true
# The go-rfc5322 module cannot currently be compiled for 32-bit OSes:
# https://github.com/ProtonMail/proton-bridge/blob/v2.1.1/BUILDS.md#prerequisites
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR

	make build-nogui
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/proton-bridge \
		"$TERMUX_PREFIX"/bin/proton-bridge
}
