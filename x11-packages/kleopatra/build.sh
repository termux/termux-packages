TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kleopatra"
TERMUX_PKG_DESCRIPTION="Certificate Manager and Unified Crypto GUI"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kleopatra-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="b9bed89fe400b47cc250900e30b2c4801a60cb5f19d19be82de3a0f09cf65f93"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi-mime, gpgmepp, kf6-kcodecs, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemmodels, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kidentitymanagement, kmailtransport, kmime, libc++, libassuan, libgpg-error, libkleo, mimetreeparser, qgpgme, qt6-qtbase"
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
