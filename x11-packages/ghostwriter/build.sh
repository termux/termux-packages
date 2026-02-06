TERMUX_PKG_HOMEPAGE=https://ghostwriter.kde.org/
TERMUX_PKG_DESCRIPTION="Text editor for Markdown"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause, BSD 3-Clause, CC0-1.0, GPL-3.0-or-later, LGPL-2.1-or-later, MIT, OFL-1.1, custom"
TERMUX_PKG_LICENSE_FILE="
LICENSES/Apache-2.0.txt
LICENSES/BSD-2-Clause.txt
LICENSES/BSD-3-Clause.txt
LICENSES/CC0-1.0.txt
LICENSES/GPL-3.0-or-later.txt
LICENSES/LGPL-2.1-or-later.txt
LICENSES/MIT.txt
LICENSES/OFL-1.1.txt
LICENSES/CC-BY-SA-4.0.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/ghostwriter-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=365fdea7669152f224271ede68c7c50f5b220cce26e4310482fed7e8c420de95
TERMUX_PKG_DEPENDS="libc++, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-sonnet, qt6-qtwebchannel, qt6-qtwebengine, qt6-qtbase, qt6-qtpositioning"
TERMUX_PKG_SUGGESTS="cmake, pandoc"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, kf6-kdoctools-cross-tools, qt6-qttools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	fi
}
