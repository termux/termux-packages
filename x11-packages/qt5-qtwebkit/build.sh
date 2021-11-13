TERMUX_PKG_HOMEPAGE=https://github.com/qtwebkit/qtwebkit
TERMUX_PKG_DESCRIPTION="Qt 5 WebKit Library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="5.212.0-alpha4"
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL="https://github.com/qtwebkit/qtwebkit/releases/download/qtwebkit-${TERMUX_PKG_VERSION}/qtwebkit-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9ca126da9273664dd23a3ccd0c9bebceb7bb534bddd743db31caf6a5a6d4a9e6
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtdeclarative, qt5-qtlocation, qt5-qtmultimedia, qt5-qtsensors, zlib, libxslt, libxcomposite, libhyphen, libwebp"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPORT=Qt -DUSE_LD_GOLD=OFF -DUSE_GSTREAMER=OFF -DUSE_QT_MULTIMEDIA=ON -DENABLE_OPENGL=OFF -DENABLE_SAMPLING_PROFILER=OFF -DENABLE_WEBKIT2=OFF"

# undefined reference to __x86.get_pc_thunk.bx
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

# TODO SAMPLING_PROFILER requires glibc. We might be able to patch the source to make it work with bionic
