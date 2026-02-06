TERMUX_PKG_HOMEPAGE="https://apps.kde.org/elisa/"
TERMUX_PKG_DESCRIPTION="A simple music player developed by KDE"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/elisa-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e64b92d62202b5a5d2bbb7d048a06ac633fbfe21cc8af9ee46f1991e97e674b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemviews, kf6-kxmlgui, kf6-qqc2-desktop-style, kirigami-addons, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, vlc-qt"
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

	LDFLAGS+=" -Wl,-rpath=$TERMUX__PREFIX__LIB_DIR/$TERMUX_PKG_NAME"
}
