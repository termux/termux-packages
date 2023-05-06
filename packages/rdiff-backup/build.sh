TERMUX_PKG_HOMEPAGE=https://rdiff-backup.net
TERMUX_PKG_DESCRIPTION="A utility for local/remote mirroring and incremental backups"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.5"
TERMUX_PKG_SRCURL=https://github.com/rdiff-backup/rdiff-backup/releases/download/v${TERMUX_PKG_VERSION/\~/}/rdiff-backup-${TERMUX_PKG_VERSION/\~/}.tar.gz
TERMUX_PKG_SHA256=86e2826b784ec3ea4ef187d936ee5f15277422c4077efa0156ef67e3139ea08e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="librsync, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	continue
}
