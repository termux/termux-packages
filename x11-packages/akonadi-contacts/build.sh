TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akonadi-contacts"
TERMUX_PKG_DESCRIPTION="Libraries and daemons to implement Contact Management in Akonadi"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akonadi-contacts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="fa4d6b95143478f7d44897c68c33ee0f030426f25d8567045b904c2a02eb3686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, grantleetheme, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcontacts, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-ktexttemplate, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-prison, kmime, ktextaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
