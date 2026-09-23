TERMUX_PKG_HOMEPAGE=https://code.videolan.org/rist/librist
TERMUX_PKG_DESCRIPTION="Library to add the RIST protocol to applications"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.20"
TERMUX_PKG_SRCURL="https://code.videolan.org/rist/librist/-/archive/v${TERMUX_PKG_VERSION}/librist-v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9e40eeb87f014790531ad41326cc271b930a65962e4b15231b301fc59b29fe31
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cjson, libmicrohttpd, liblz4, mbedtls"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtest=false
"
