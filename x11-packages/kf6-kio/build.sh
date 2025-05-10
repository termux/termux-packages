TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Resource and network access abstraction'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.14.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9b03746fd008504a96f569f37ad8ff902cc71495e7e123daa3c6de79ff2acc45
TERMUX_PKG_DEPENDS="kf6-karchive (>= ${TERMUX_PKG_VERSION}), kf6-kauth (>= ${TERMUX_PKG_VERSION}), kf6-kbookmarks (>= ${TERMUX_PKG_VERSION}), kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION}), kf6-kcompletion (>= ${TERMUX_PKG_VERSION}), kf6-kconfig (>= ${TERMUX_PKG_VERSION}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION}), kf6-kdbusaddons (>= ${TERMUX_PKG_VERSION}), kf6-kguiaddons (>= ${TERMUX_PKG_VERSION}), kf6-ki18n (>= ${TERMUX_PKG_VERSION}), kf6-kiconthemes (>= ${TERMUX_PKG_VERSION}), kf6-kitemviews (>= ${TERMUX_PKG_VERSION}), kf6-kjobwidgets (>= ${TERMUX_PKG_VERSION}), kf6-kservice (>= ${TERMUX_PKG_VERSION}), kf6-kwallet (>= ${TERMUX_PKG_VERSION}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION}), kf6-kwindowsystem (>= ${TERMUX_PKG_VERSION}), kf6-solid (>= ${TERMUX_PKG_VERSION}), libacl, libandroid-shmem, libc++, libmount, libxml2, libxslt, qt6-qtbase, util-linux"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
}
