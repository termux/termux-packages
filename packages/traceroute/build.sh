TERMUX_PKG_HOMEPAGE=https://traceroute.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A new modern implementation of traceroute(8) utility for Linux systems"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.5"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/traceroute/traceroute/traceroute-${TERMUX_PKG_VERSION}/traceroute-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9c6c260d96eaab51e3ce461b0a84fe87123ebc6dd6c9a59fab803f95b35a859e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_CONFLICTS="tracepath (<< 20221126-1)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX -e"

termux_step_configure() {
	:
}
