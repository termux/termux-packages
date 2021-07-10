TERMUX_PKG_HOMEPAGE=https://github.com/ProtonMail/proton-bridge
TERMUX_PKG_DESCRIPTION="ProtonMail Bridge application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.5.7
TERMUX_PKG_SRCURL=https://github.com/ProtonMail/proton-bridge.git
TERMUX_PKG_GIT_BRANCH=br-$TERMUX_PKG_VERSION
TERMUX_PKG_MAINTAINER="Radomír Polách <rp@t4d.cz>"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go mod tidy
	# TODO: Cache go dependencies `termux_go_deps` after new release of proton-bridge
	make build-nogui
}

termux_step_make_install() {
	install -Dm700 proton-bridge "$TERMUX_PREFIX"/bin/proton-bridge
}
