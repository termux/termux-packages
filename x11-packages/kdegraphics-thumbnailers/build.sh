TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/kdegraphics-thumbnailers"
TERMUX_PKG_DESCRIPTION="Thumbnailers for various graphics file formats"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdegraphics-thumbnailers-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=2d16907d630bce50b1b072f2f35d0c577c178b794dcc8014443130cbb52ed628
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ghostscript, kdegraphics-mobipocket, kf6-karchive, kf6-kcoreaddons, kf6-kio, libc++, libkdcraw, libkexiv2, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
