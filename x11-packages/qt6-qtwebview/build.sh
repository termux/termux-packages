TERMUX_PKG_HOMEPAGE="https://www.qt.io/"
TERMUX_PKG_DESCRIPTION="Provides a way to display web content in a QML application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtwebview-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=cb0eaed94a12d5f650863d346c423e9f4383dbce1d05866869c40118c6e8c4b3
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
