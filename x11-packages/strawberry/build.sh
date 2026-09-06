TERMUX_PKG_HOMEPAGE=https://www.strawberrymusicplayer.org/
TERMUX_PKG_DESCRIPTION="Audio player and music collection organizer"
TERMUX_PKG_LICENSE="Apache-2.0, GPL-2.0-or-later, GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.30"
TERMUX_PKG_SRCURL="https://github.com/strawberrymusicplayer/strawberry/releases/download/${TERMUX_PKG_VERSION}/strawberry-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=30fea0fdfc2f9c5449ac30d78ac2f5429fb5e1d025a4d1d3473d10f2abe1ef2a
TERMUX_PKG_DEPENDS="alsa-lib, fftw, gdk-pixbuf, glib, gst-plugins-base, gst-plugins-good, gstreamer, kdsingleapplication, libc++, libchromaprint, libebur128, libicu, libmtp, libsqlite, libx11, pulseaudio, qt6-qtbase, qt6-qtsvg, taglib"
TERMUX_PKG_BUILD_DEPENDS="boost, gst-libav, gst-plugins-bad, gst-plugins-ugly, qt6-qtbase-cross-tools, qt6-qttools, rapidjson, sparsehash"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_AUDIOCD=OFF
-DENABLE_DISCORD_RPC=OFF
-DENABLE_GPOD=OFF
-DENABLE_UDISKS2=OFF
"
