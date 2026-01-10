TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/kjobwidgets'
TERMUX_PKG_DESCRIPTION='Widgets for tracking KJob instances'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kjobwidgets-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ce864bcdb4dcfd3fcf0afc3e3e2fcb86780c9242252315bc003fb547af7463f0
TERMUX_PKG_DEPENDS="kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION%.*}), kf6-knotifications (>= ${TERMUX_PKG_VERSION%.*}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
