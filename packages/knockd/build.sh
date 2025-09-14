TERMUX_PKG_HOMEPAGE=https://zeroflux.org/projects/knock
TERMUX_PKG_DESCRIPTION="A port-knocking daemon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.2"
TERMUX_PKG_REVISION=2
# Original hasnt been maintained in a long time - use this fork instead - includes IPv6 support
TERMUX_PKG_SRCURL=https://github.com/TDFKAOlli/knock/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5814eac3d8337c64be88520300d56396256186522445e904ad51d14ba0e922f
TERMUX_PKG_DEPENDS="libpcap"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}
