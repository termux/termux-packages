TERMUX_PKG_HOMEPAGE=https://codeberg.org/emersion/soju
TERMUX_PKG_DESCRIPTION="A user-friendly IRC bouncer"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.1"
TERMUX_PKG_SRCURL="https://codeberg.org/emersion/soju/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=42f0b422267fb039ae598d34122f89857fe0cb590baf7136032bf46a244b00eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/lib/soju
	EOF
}
