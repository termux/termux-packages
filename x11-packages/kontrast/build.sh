TERMUX_PKG_HOMEPAGE="https://invent.kde.org/accessibility/kontrast"
TERMUX_PKG_DESCRIPTION="Tool to check contrast for colors that allows verifying that your colors are correctly accessible"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kontrast-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=04aeda7b16205c3cd1f65a0e4a9c99c8cdf5897ac72494db55dec01b729c7bb3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="futuresql, kirigami-addons, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kirigami, libc++, qcoro, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qcoro-static, kf6-kdoctools"
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
