TERMUX_PKG_HOMEPAGE=https://github.com/WindSoilder/hors
TERMUX_PKG_DESCRIPTION="Instant coding answers via the command line (howdoi in rust)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_SRCURL=https://github.com/WindSoilder/hors/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0e37fc5bb743ca577f5cae686feae5b3f6b756e69951bd441336b4a008063d7
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi

	rm -f Makefile
}
