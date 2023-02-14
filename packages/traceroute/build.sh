TERMUX_PKG_HOMEPAGE=http://traceroute.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A new modern implementation of traceroute(8) utility for Linux systems"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/traceroute/traceroute/traceroute-${TERMUX_PKG_VERSION}/traceroute-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=507c268f2977b4e218ce73e7ebed45ba0d970a8ca4995dd9cbb1ffe8e99b5b1f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX -e"

termux_step_configure() {
	:
}
