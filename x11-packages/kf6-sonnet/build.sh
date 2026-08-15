TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/sonnet'
TERMUX_PKG_DESCRIPTION='Spelling framework for Qt'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/sonnet-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=45501e804f242a93779402f87dbb422981699b91b5ecde97c67fd11f4f19e2ad
TERMUX_PKG_DEPENDS="aspell, hunspell, libc++, libvoikko, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools, qt6-qtbase-cross-tools"
# hspell can be added to TERMUX_PKG_BUILD_DEPENDS and TERMUX_PKG_RECOMMENDS when available
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
