TERMUX_PKG_HOMEPAGE=http://www.fresse.org/dateutils/
TERMUX_PKG_DESCRIPTION="Command line date and time utilities"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.4.11
TERMUX_PKG_SRCURL=https://github.com/hroptatyr/dateutils/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9041b220b8cdb0e4e12292d8f71e7ad65fffd67873e96a3e52bfd226240deaec
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='--with-old-links=no --enable-contrib=yes --disable-silent-rules'
#TERMUX_PKG_DEPENDS=""
termux_step_pre_configure() {
	autoreconf -fi
	# ./configure --help
}

# termux_step_post_configure() {
# 	ls -RAl ./build-aux
# }
