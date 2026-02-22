TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/calendarsupport"
TERMUX_PKG_DESCRIPTION="Calendar support library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/calendarsupport-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="ca88695936e64d01acbf34476b7215f1796a366b96cc43890a3e3e1a3320b92d"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-calendar, kcalutils, kf6-kcalendarcore, kf6-kcodecs, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, kf6-kholidays, kf6-ki18n, kf6-kio, kf6-kservice, kf6-kwidgetsaddons, kidentitymanagement, kmime, libc++, qt6-qtbase"
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
