TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/libqaccessibilityclient"
TERMUX_PKG_DESCRIPTION="Helper library to make writing accessibility tools easier"
TERMUX_PKG_LICENSE="LGPL-2.1-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/Attic/libqaccessibilityclient/libqaccessibilityclient-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4c50c448622dc9c5041ed10da7d87b3e4e71ccb49d4831a849211d423c5f5d33"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtbase"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_WITH_QT6=ON
"
