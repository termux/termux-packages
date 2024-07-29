TERMUX_PKG_HOMEPAGE='https://packages.debian.org/sid/source/bsd-finger'
TERMUX_PKG_DESCRIPTION="User information lookup program"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/bsd-finger/-/archive/upstream/${TERMUX_PKG_VERSION}/bsd-finger-upstream-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=56e18928a04b38eadea741f9f07db6155ce56b6992defba3c0e32f9caeee9109
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	sed -n '1,/*\//p' finger/finger.c > LICENSE
}

termux_step_configure() {
	./configure
}
