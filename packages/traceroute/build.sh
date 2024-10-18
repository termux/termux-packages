TERMUX_PKG_HOMEPAGE=https://traceroute.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A new modern implementation of traceroute(8) utility for Linux systems"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.6"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/traceroute/traceroute/traceroute-${TERMUX_PKG_VERSION}/traceroute-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ccef9cdb9d7a98ff7fbf93f79ebd0e48881664b525c4b232a0fcec7dcb9db5e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_CONFLICTS="tracepath (<< 20221126-1)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX -e"

termux_step_configure() {
	:
}
