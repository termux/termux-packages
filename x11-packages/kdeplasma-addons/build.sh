TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kdeplasma-addons"
TERMUX_PKG_DESCRIPTION="All kind of addons to improve your Plasma experience"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kdeplasma-addons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=df58519038f8fa02f399c3ebd06d6860880641f2bd68566b2207212f9ba34235
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kauth, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kdeclarative, kf6-kglobalaccel, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-kjobwidgets, kf6-knewstuff, kf6-knotifications, kf6-kpackage, kf6-krunner, kf6-kservice, kf6-ksvg, kf6-kunitconversion, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-sonnet, kirigami-addons, kwin-x11, libc++, libicu, libplasma, plasma-workspace, plasma5support, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtwebengine"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
