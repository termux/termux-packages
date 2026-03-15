TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kontact"
TERMUX_PKG_DESCRIPTION="KDE Personal Information Manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kontact-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4124c873d26a9047332aeeac8002a5619a1455f19280538f191efbf6edeef604"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akregator, grantleetheme, kaddressbook, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kjobwidgets, kf6-kparts, kf6-kservice, kf6-kwidgetsaddons, kf6-kxmlgui, kmail, kmail-account-wizard, kontactinterface, korganizer, libc++, libkdepim, pimcommon, qt6-qtbase, qt6-qtwebengine, zanshin"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
