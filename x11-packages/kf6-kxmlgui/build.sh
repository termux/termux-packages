TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='User configurable main windows'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.7.0
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kxmlgui-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a451c16d70a591de13973079115f35905e3c42302f5c8c8ae3ec75d76a06fca1
TERMUX_PKG_DEPENDS="kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION}), kf6-kconfig (>= ${TERMUX_PKG_VERSION}), kf6-kconfigwidgets (>= ${TERMUX_PKG_VERSION}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION}), kf6-kglobalaccel (>= ${TERMUX_PKG_VERSION}), kf6-kguiaddons (>= ${TERMUX_PKG_VERSION}), kf6-ki18n (>= ${TERMUX_PKG_VERSION}), kf6-kiconthemes (>= ${TERMUX_PKG_VERSION}), kf6-kitemviews (>= ${TERMUX_PKG_VERSION}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION}), qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
