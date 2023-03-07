TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="An advanced audio player"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=4.3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=27584dc845c7e70db8c9267990945f17322a1ecc80ff8b452e9ca916a0ce9091
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, dbus-glib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_RECOMMENDS="audacious-plugins"
# Audacious out-of-source build doesn't seem to work
TERMUX_PKG_BUILD_IN_SRC=true
# Audacious has switched to Qt toolkit and it's the default GUI option now
# Disable GTK to reduce the size and dependencies
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-qt --disable-gtk"
