TERMUX_PKG_HOMEPAGE=http://supercollider.github.io/
TERMUX_PKG_DESCRIPTION="A platform for audio synthesis and algorithmic composition"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, GPL-3.0"
TERMUX_PKG_MAINTAINER="@rene-descartes2021"
TERMUX_PKG_VERSION="3.14.1"
TERMUX_PKG_SRCURL="https://github.com/supercollider/supercollider/releases/download/Version-${TERMUX_PKG_VERSION}/SuperCollider-${TERMUX_PKG_VERSION}-Source.tar.bz2"
TERMUX_PKG_SHA256=ee640c68777ae697682066ce5c4a8b7e56c5b223e76c79c13b5be5387ee55bb2
TERMUX_PKG_DEPENDS="boost, fftw, jack2, libandroid-glob, libsndfile, libyaml-cpp, readline"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DAUDIOAPI=jack
-DSC_QT=OFF
-DSC_HIDAPI=OFF
-DNO_X11=ON
-DNO_AVAHI=ON
-DSC_ABLETON_LINK=OFF
-DSYSTEM_YAMLCPP=ON
-DSYSTEM_BOOST=ON
-DSUPERNOVA=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
