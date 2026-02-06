TERMUX_PKG_HOMEPAGE="https://apps.kde.org/angelfish"
TERMUX_PKG_DESCRIPTION="Web browser for Plasma Mobile"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/angelfish-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=dabbea6967ad7614afc9f92811be51c708564af46657e8fd5a07ba752c8f785e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="futuresql, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kirigami, kf6-knotifications, kf6-kwindowsystem, kf6-purpose, kf6-qqc2-desktop-style, kirigami-addons, libc++, qcoro, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="corrosion, extra-cmake-modules, qcoro-static"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	termux_setup_rust

	[[ "${TERMUX_ARCH}" == "arm" ]] && TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ANDROID_ARM_MODE=ON"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRust_CARGO_TARGET=$CARGO_TARGET_NAME"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	fi
}
