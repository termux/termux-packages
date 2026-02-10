TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kcalutils"
TERMUX_PKG_DESCRIPTION="The KDE calendar utility library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kcalutils-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="a822d1cc8c2b08ae7944c6a574f32f91abe3a1b86adecf70e8bea4b353de88f6"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcalendarcore, kf6-kcodecs, kf6-kcoreaddons, kf6-ki18n, kf6-kiconthemes, kf6-ktexttemplate, kf6-kwidgetsaddons, kidentitymanagement, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
