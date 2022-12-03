TERMUX_PKG_HOMEPAGE=https://git.linuxtv.org/v4l-utils.git
TERMUX_PKG_DESCRIPTION="Linux libraries to handle media devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.1
TERMUX_PKG_SRCURL=https://linuxtv.org/downloads/v4l-utils/v4l-utils-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=65c6fbe830a44ca105c443b027182c1b2c9053a91d1e72ad849dfab388b94e31
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob, libjpeg-turbo"
TERMUX_PKG_BUILD_DEPENDS="argp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-v4l-utils
--disable-qv4l2
"

termux_step_pre_configure() {
	local f
	for f in lib/*/Makefile.in; do
		sed -i '/_la_LDFLAGS = /s/ -lpthread//' ${f}
		sed -i '/_la_LDFLAGS = /s/ -lrt / /' ${f}
	done
}
