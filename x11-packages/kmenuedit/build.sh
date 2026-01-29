TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kmenuedit"
TERMUX_PKG_DESCRIPTION="KDE menu editor"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kmenuedit-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4505d8205e2dc8d009e0bb83080088d499085c1675fbedb553b21bd2fd1f029f"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-kservice, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-sonnet, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_DOC=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
