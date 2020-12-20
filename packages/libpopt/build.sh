TERMUX_PKG_HOMEPAGE=http://www.linuxfromscratch.org/blfs/view/svn/general/popt.html
TERMUX_PKG_DESCRIPTION="Library for parsing cmdline parameters"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/p/popt/popt_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=5159bc03a20b28ce363aa96765f37df99ea4d8850b1ece17d1e6ad5c24fdc5d1
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BREAKS="libpopt-dev"
TERMUX_PKG_REPLACES="libpopt-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
