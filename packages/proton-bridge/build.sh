TERMUX_PKG_HOMEPAGE=https://github.com/ProtonMail/proton-bridge
TERMUX_PKG_DESCRIPTION="ProtonMail Bridge application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.4.5
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p $TERMUX_PKG_SRCDIR

	git clone https://github.com/ProtonMail/proton-bridge.git $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	git checkout "br-$TERMUX_PKG_VERSION"
}

termux_step_make_install() {
	export BUILDDIR=$TERMUX_PREFIX/bin
	cd $TERMUX_PKG_SRCDIR
	make build-nogui
	install -Dm700 Desktop-Bridge "$TERMUX_PREFIX"/bin/proton-bridge
}
