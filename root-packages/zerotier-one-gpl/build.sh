TERMUX_PKG_HOMEPAGE=https://www.zerotier.com/
TERMUX_PKG_DESCRIPTION="Creates virtual Ethernet networks of almost unlimited size"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SRCURL=https://github.com/zerotier/ZeroTierOne/archive/refs/tags/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=557a444127812384265ec97232bae43dce1d4b1545ddd72e2b1646c971dad7c5
TERMUX_PKG_DEPENDS="natpmpc, miniupnpc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	'zerotier-one' 'exec su -c "':$TERMUX_PREFIX'/bin/zerotier-one -d"'
)

termux_step_configure() {
	:
}

termux_step_post_configure() {
	export AS="as"
}
