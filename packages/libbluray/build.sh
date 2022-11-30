TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libbluray/
TERMUX_PKG_DESCRIPTION="An open-source library designed for Blu-Ray Discs playback for media players"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/libbluray/${TERMUX_PKG_VERSION}/libbluray-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=478ffd68a0f5dde8ef6ca989b7f035b5a0a22c599142e5cd3ff7b03bbebe5f2b
TERMUX_PKG_DEPENDS="fontconfig, freetype, libudfread, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-bdjava-jar
--disable-optimizations
"

termux_step_pre_configure() {
	unset JDK_HOME
}
