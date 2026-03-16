TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/itinerary"
TERMUX_PKG_DESCRIPTION="Itinerary and boarding pass management application"
TERMUX_PKG_LICENSE="BSD, LGPL-2.0-or-later"
TERMUX_PKG_LICENSE_FILE="
LICENSES/BSD-3-Clause.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/itinerary-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="9ad5a9228cea5042e293e01a8bb61f643ea5efe6ea4dfdf7f3a62bf4f5b07293"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcalendarcore, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-kholidays, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-knotifications, kf6-kunitconversion, kf6-kwindowsystem, kf6-prison, kf6-qqc2-desktop-style, khealthcertificate, kirigami-addons, kitinerary, kosmindoormap, kpkpass, kpublictransport, libc++, libquotient, qcoro, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qtmultimedia, qt6-qtpositioning, qtkeychain, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libquotient-static, python, qcoro-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
