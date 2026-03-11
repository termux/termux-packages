TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/incidenceeditor"
TERMUX_PKG_DESCRIPTION="KDE PIM incidence editor"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/incidenceeditor-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="a14342bbc4531153802d74d3405df459f4611554571f559824811e52b2886d36"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, calendarsupport, eventviews, kcalutils, kdiagram, kf6-kcalendarcore, kf6-kcodecs, kf6-kcompletion, kf6-kconfig, kf6-kcontacts, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kitemmodels, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, kidentitymanagement, kldap, kmime, kpimtextedit, libc++, libkdepim, pimcommon, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
# akonadi, akonadi-calendar, akonadi-contacts, akonadi-mime, calendarsupport, eventviews, pimcommon depends on qt6-qtwebengine
# qt6-qtwebengine is not supported on the i686 architecture
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
