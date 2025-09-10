TERMUX_PKG_HOMEPAGE=https://rdiff-backup.net
TERMUX_PKG_DESCRIPTION="A utility for local/remote mirroring and incremental backups"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.6"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/rdiff-backup/rdiff-backup/releases/download/v${TERMUX_PKG_VERSION/\~/}/rdiff-backup-${TERMUX_PKG_VERSION/\~/}.tar.gz
TERMUX_PKG_SHA256=d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="librsync, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	continue
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install pyyaml
	EOF
}
