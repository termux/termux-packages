TERMUX_PKG_HOMEPAGE=https://rdiff-backup.net
TERMUX_PKG_DESCRIPTION="A utility for local/remote mirroring and incremental backups"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.3"
TERMUX_PKG_SRCURL=https://github.com/rdiff-backup/rdiff-backup/releases/download/v${TERMUX_PKG_VERSION/\~/}/rdiff-backup-${TERMUX_PKG_VERSION/\~/}.tar.gz
TERMUX_PKG_SHA256=0ec0e7c75277fa3f1d02fcc9c91c0b58e10c5e625cefd5ffd6b56ec293878fc9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="librsync, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	continue
}
