TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libbluray/
TERMUX_PKG_DESCRIPTION="An open-source library designed for Blu-Ray Discs playback for media players"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/libbluray/${TERMUX_PKG_VERSION}/libbluray-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=58ff52cdcee64c55dcc3c777a1c39fb41abd951b927978e4d2b6811b9193a488
TERMUX_PKG_DEPENDS="fontconfig, freetype, libudfread, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-bdjava-jar
--disable-optimizations
"

termux_step_pre_configure() {
	unset JDK_HOME
}
