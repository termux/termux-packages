TERMUX_PKG_HOMEPAGE=https://rdiff-backup.net
TERMUX_PKG_DESCRIPTION="A utility for local/remote mirroring and incremental backups"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rdiff-backup/rdiff-backup/releases/download/v${TERMUX_PKG_VERSION/\~/}/rdiff-backup-${TERMUX_PKG_VERSION/\~/}.tar.gz
TERMUX_PKG_SHA256=4ce1ddd8ab15f4faed8cf547397b77ef10405c084bd61cb2a999f0ed1f78c1b9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="librsync, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	continue
}
