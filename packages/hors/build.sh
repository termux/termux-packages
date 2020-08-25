TERMUX_PKG_HOMEPAGE=https://github.com/WindSoilder/hors
TERMUX_PKG_DESCRIPTION="Instant coding answers via the command line (howdoi in rust)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.6.9
TERMUX_PKG_SRCURL=https://github.com/WindSoilder/hors/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a4737bc04b77d035b7b57d99cad875e709044ef829febdf9da87a6dde67d8c79
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	rm -f Makefile
}
