TERMUX_PKG_HOMEPAGE="https://apps.kde.org/neochat/"
TERMUX_PKG_DESCRIPTION="A client for matrix, the decentralized communication protocol"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/neochat-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="e97c89c39628eb77977135b42f774353c0c05f74759fd3b7eed17f042c4fb626"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cmark, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-knotifications, kf6-kquickcharts, kf6-kservice, kf6-kstatusnotifieritem, kf6-kwindowsystem, kf6-prison, kf6-purpose, kf6-qqc2-desktop-style, kf6-sonnet, kf6-syntax-highlighting, kirigami-addons, kquickimageeditor, kunifiedpush, libc++, libicu, libquotient, qcoro, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qtmultimedia, qt6-qtpositioning, qt6-qtspeech, qt6-qtwebview, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="cmark-static, extra-cmake-modules, kf6-kdoctools, libquotient-static, qcoro-static"
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
