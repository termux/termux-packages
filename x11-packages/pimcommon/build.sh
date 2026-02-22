TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/pimcommon"
TERMUX_PKG_DESCRIPTION="Common libraries for KDE PIM"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/pimcommon-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="7da324710ea6077fa247ec04db666c172352ba0e61f1df9aa07ab7109ac5290b"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-search, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcontacts, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kitemmodels, kf6-kitemviews, kf6-knewstuff, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-purpose, kimap, kldap, ktextaddons, libc++, libkdepim, plasma-activities, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
