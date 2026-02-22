TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/akonadi-search"
TERMUX_PKG_DESCRIPTION="Libraries and daemons to implement searching in Akonadi"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/akonadi-search-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="8328094f725ed4603e2309bf381d1a407baa38032e157f2e7421f3c53e2e21ce"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, akonadi-mime, kf6-kcalendarcore, kf6-kcmutils, kf6-kcodecs, kf6-kconfig, kf6-kcontacts, kf6-kcoreaddons, kf6-ki18n, kf6-krunner, kf6-kwidgetsaddons, kmime, ktextaddons, libc++, libxapian, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, corrosion"
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
}
