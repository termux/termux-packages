TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kirigami-addons"
TERMUX_PKG_DESCRIPTION="Add-ons for the Kirigami framework"
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/kirigami-addons/kirigami-addons-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c98f92bf7c452e12f6dc403404215413db3959fe904ad830ead0db6bb09b3d11
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kglobalaccel, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kirigami, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
