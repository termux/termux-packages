TERMUX_PKG_HOMEPAGE="https://github.com/KDAB/KDSingleApplication"
TERMUX_PKG_DESCRIPTION="KDAB's helper class for single-instance policy applications"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/KDAB/KDSingleApplication/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ff4ae6a4620beed1cdb3e6a9b78a17d7d1dae7139c3d4746d4856b7547d42c38
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDSingleApplication_QT6=ON
"
