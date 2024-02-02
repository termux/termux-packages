TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~emersion/soju
TERMUX_PKG_DESCRIPTION="A user-friendly IRC bouncer"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://git.sr.ht/~emersion/soju/refs/download/v${TERMUX_PKG_VERSION}/soju-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d776a28bfb2b7f9cdca0336a5debc4888b224812094daf0de0e29bae9c865cf
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
