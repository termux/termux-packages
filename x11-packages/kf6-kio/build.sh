TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Resource and network access abstraction'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.14.0"
TERMUX_PKG_REVISION=1
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9b03746fd008504a96f569f37ad8ff902cc71495e7e123daa3c6de79ff2acc45
TERMUX_PKG_DEPENDS="kf6-karchive (>= ${_KF6_MINOR_VERSION}), kf6-kauth (>= ${_KF6_MINOR_VERSION}), kf6-kbookmarks (>= ${_KF6_MINOR_VERSION}), kf6-kcolorscheme (>= ${_KF6_MINOR_VERSION}), kf6-kcompletion (>= ${_KF6_MINOR_VERSION}), kf6-kconfig (>= ${_KF6_MINOR_VERSION}), kf6-kcoreaddons (>= ${_KF6_MINOR_VERSION}), kf6-kdbusaddons (>= ${_KF6_MINOR_VERSION}), kf6-kguiaddons (>= ${_KF6_MINOR_VERSION}), kf6-ki18n (>= ${_KF6_MINOR_VERSION}), kf6-kiconthemes (>= ${_KF6_MINOR_VERSION}), kf6-kitemviews (>= ${_KF6_MINOR_VERSION}), kf6-kjobwidgets (>= ${_KF6_MINOR_VERSION}), kf6-kservice (>= ${_KF6_MINOR_VERSION}), kf6-kwallet (>= ${_KF6_MINOR_VERSION}), kf6-kwidgetsaddons (>= ${_KF6_MINOR_VERSION}), kf6-kwindowsystem (>= ${_KF6_MINOR_VERSION}), kf6-solid (>= ${_KF6_MINOR_VERSION}), libacl, libandroid-shmem, libc++, libmount, libxml2, libxslt, qt6-qtbase, util-linux"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
}
