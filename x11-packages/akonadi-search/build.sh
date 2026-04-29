TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akonadi-search"
TERMUX_PKG_DESCRIPTION="Libraries and daemons to implement searching in Akonadi"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akonadi-search-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="14b98b08c9515ffc886d30d0d950a77e607eba508a73ce4f577bab314dece132"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-mime, kf6-kcalendarcore, kf6-kcmutils, kf6-kcodecs, kf6-kconfig, kf6-kcontacts, kf6-kcoreaddons, kf6-ki18n, kf6-krunner, kf6-kwidgetsaddons, kmime, ktextaddons, libc++, libxapian, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="corrosion, extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DCMAKE_MODULE_PATH=$TERMUX_PREFIX/share/cmake
"

termux_step_pre_configure() {
	termux_setup_rust

	[[ "${TERMUX_ARCH}" == "arm" ]] && TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ANDROID_ARM_MODE=ON"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRust_CARGO_TARGET=$CARGO_TARGET_NAME"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	fi
}
