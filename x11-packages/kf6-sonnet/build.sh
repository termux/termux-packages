TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Spelling framework for Qt'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.15.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/sonnet-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0f7c7315afbaf2c8f7d898d4a960c5bbab851e65338f79aee54f76e925234886
TERMUX_PKG_DEPENDS="aspell, hunspell, libc++, libvoikko, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qttools, qt6-qtbase-cross-tools"
# hspell can be added to TERMUX_PKG_BUILD_DEPENDS and TERMUX_PKG_RECOMMENDS when available
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
