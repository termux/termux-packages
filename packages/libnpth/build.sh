TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/npth/
TERMUX_PKG_DESCRIPTION="New GNU Portable Threads Library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/npth/npth-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8bd24b4f23a3065d6e5b26e98aba9ce783ea4fd781069c1b35d149694e90ca3e
TERMUX_PKG_BREAKS="libnpth-dev"
TERMUX_PKG_REPLACES="libnpth-dev"

termux_step_pre_configure() {
	export ac_cv_search_pthread_cancel="none required"
}
