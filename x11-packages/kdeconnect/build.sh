TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/kdeconnect-kde"
TERMUX_PKG_DESCRIPTION="Adds communication between KDE and your smartphone"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdeconnect-kde-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="8a340bdc48a754d12a938f231a366f308de2121614e7628b86a1bbfa509d351f"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdeclarative, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kirigami-addons, kf6-kitemmodels, kf6-kjobwidgets, kf6-knotifications, kf6-kpeople, kf6-kservice, kf6-kstatusnotifieritem, kf6-kwindowsystem, libfakekey, libx11, libxkbcommon, libxtst, openssl, pulseaudio-qt, kf6-qqc2-desktop-style, qt6-qtbase, qt6-qtconnectivity, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtwayland, kf6-solid, libc++, libwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kpackage, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
