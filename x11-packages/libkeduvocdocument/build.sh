TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/libkeduvocdocument"
TERMUX_PKG_DESCRIPTION="Common libraries for KDE Edu applications"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libkeduvocdocument-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=023c9bb69a98ddb897bc15dd0e526f98817f20acb6cf34068a8382d850003b64
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kdeedu-data, kf6-karchive, kf6-kcoreaddons, kf6-ki18n, kf6-kio, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
