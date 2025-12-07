TERMUX_PKG_HOMEPAGE="https://api.kde.org/legacy/futuresql/html/index.html"
TERMUX_PKG_DESCRIPTION="Non-blocking Qt database framework"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.1"
TERMUX_PKG_SRCURL="https://download.kde.org/Attic/futuresql/futuresql-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="e44ed8d5a9618b3ca7ba2983ed9c5f7572e6e0a5b199f94868834b71ccbebd43"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_WITH_QT6=ON
"
