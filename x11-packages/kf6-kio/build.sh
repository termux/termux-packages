TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Resource and network access abstraction'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.0
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=977f9f076eaf249ecdd961724334326c3f3a1e7d8cfcc6ca1370f390c76a2766
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kauth, kf6-kbookmarks, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kitemviews, kf6-kjobwidgets, kf6-kservice, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, libacl, libmount, libxml2, libxslt, qt6-qt5compat, qt6-qtbase, kf6-solid, util-linux"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
# TERMUX_PKG_RECOMMENDS="kded, kio-extras"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
}
