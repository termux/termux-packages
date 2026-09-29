TERMUX_PKG_HOMEPAGE=https://libtins.github.io
TERMUX_PKG_DESCRIPTION="High-level, multiplatform C++ network packet sniffing and crafting library."
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6"
TERMUX_PKG_SRCURL="https://github.com/mfontanini/libtins/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=37a9cc407929c56c2081e717347cac455287ba354016bad5bad6243d1f0a4a7a
TRRMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libpcap, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BREAKS="libtins-dev"
TERMUX_PKG_REPLACES="libtins-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
