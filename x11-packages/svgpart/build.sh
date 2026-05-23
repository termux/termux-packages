TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/svgpart"
TERMUX_PKG_DESCRIPTION="A KPart for viewing SVGs"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/svgpart-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="a2accc400f0251d0be462b0d1d99cf2ba1bfb99ebf019b03dd2d60de9e152513"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kparts, kf6-kxmlgui, libc++, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
