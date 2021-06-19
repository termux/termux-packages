TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Qt port of volume control of sound server PulseAudio"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/lxqt/pavucontrol-qt/releases/download/${TERMUX_PKG_VERSION}/pavucontrol-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=6c274cd3a80a699c4b3f4dbf4eccaef3fafdc677c6240e2b45672bafe46da170
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, liblxqt, pulseaudio-glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

