TERMUX_PKG_HOMEPAGE=https://github.com/WindSoilder/hors
TERMUX_PKG_DESCRIPTION="Instant coding answers via the command line (howdoi in rust)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_SRCURL=https://github.com/WindSoilder/hors/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7feceb88d2c27a8cf7fc3996c8dc464e8b6d1fe42412ce8b80e4047c7c790a16
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	rm -f Makefile
}
