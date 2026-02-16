TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akonadi-calendar"
TERMUX_PKG_DESCRIPTION="Akonadi calendar integration"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akonadi-calendar-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="ec5a5440d9a8b200f5018e23b52c4329fa401ad35408812be4a0f4b45fb77a75"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-contacts, akonadi-mime, gpgmepp, kcalutils, kf6-kcalendarcore, kf6-kcodecs, kf6-kconfig, kf6-kcontacts, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kio, kf6-kitemmodels, kf6-knotifications, kf6-kservice, kf6-kwidgetsaddons, kf6-kxmlgui, kidentitymanagement, kmailtransport, kmime, libc++, libkleo, messagelib, qgpgme, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
