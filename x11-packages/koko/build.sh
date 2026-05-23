TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/koko"
TERMUX_PKG_DESCRIPTION="Image gallery application"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/koko-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="70810148e2f86325017ea6c6446d17dfb960fd8ce66b5d9f9ec0e7b8d142d954"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exiv2, kirigami-addons, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdeclarative, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-knotifications, kf6-kwindowsystem, kf6-purpose, kf6-qqc2-desktop-style, kquickimageeditor, libc++, libxcb, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtpositioning, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
