TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/qqc2-desktop-style'
TERMUX_PKG_DESCRIPTION='A style for Qt Quick Controls 2 to make it follow your desktop theme'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/qqc2-desktop-style-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a7aa7e0b20d51ffb91f0446640a5e052369c433ef48e3526b4f507384ce7980d
TERMUX_PKG_DEPENDS="kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-kiconthemes (>= ${TERMUX_PKG_VERSION%.*}), kf6-kirigami (>= ${TERMUX_PKG_VERSION%.*}), kf6-sonnet (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_post_massage() {
	local file="lib/qt6/plugins/kf6/kirigami/platform/org.kde.desktop.so"
	if [[ ! -f "${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/${file}" ]]; then
		termux_error_exit "'$TERMUX_PKG_NAME' is malformed, '$file' must exist!"
	fi
}
