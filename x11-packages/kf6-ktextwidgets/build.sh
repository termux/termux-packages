TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Advanced text editing widgets'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.18.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/ktextwidgets-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9afb136806e8b95c34211e1dae66e4cf14d7aac2ab244d5264caac4e823d8edf
TERMUX_PKG_DEPENDS="kf6-kcolorscheme (>= ${_KF6_MINOR_VERSION}), kf6-kcompletion (>= ${_KF6_MINOR_VERSION}), kf6-kconfig (>= ${_KF6_MINOR_VERSION}), kf6-kconfigwidgets (>= ${_KF6_MINOR_VERSION}), kf6-ki18n (>= ${_KF6_MINOR_VERSION}), kf6-kwidgetsaddons (>= ${_KF6_MINOR_VERSION}), kf6-sonnet (>= ${_KF6_MINOR_VERSION}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_TEXT_TO_SPEECH=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
# qt6-qttexttospeech can be added to TERMUX_PKG_DEPENDS when available, and -DWITH_TEXT_TO_SPEECH=OFF can be removed from TERMUX_PKG_EXTRA_CONFIGURE_ARGS
