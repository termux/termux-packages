TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/aurorae"
TERMUX_PKG_DESCRIPTION="A themeable window decoration for KWin"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/aurorae-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="b358a775772052e46b4978c63ad765996ca4600af0db1189260129fd91de6589"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kdecoration, kf6-ki18n, kf6-kirigami, kf6-knewstuff, kf6-kpackage, kf6-ksvg, qt6-qtbase, qt6-qtdeclarative, bash"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
