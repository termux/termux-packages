TERMUX_PKG_HOMEPAGE=https://github.com/WindSoilder/hors
TERMUX_PKG_DESCRIPTION="Instant coding answers via the command line (howdoi in rust)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.8.2
TERMUX_PKG_SRCURL=https://github.com/WindSoilder/hors/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22419b26f64a2793759d3a3616df58196897cd9227074f475aeb3e1c366296a9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi

	rm -f Makefile
}
