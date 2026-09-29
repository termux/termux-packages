TERMUX_PKG_HOMEPAGE="https://github.com/KDAB/KDSingleApplication"
TERMUX_PKG_DESCRIPTION="KDAB's helper class for single-instance policy applications"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_SRCURL="https://github.com/KDAB/KDSingleApplication/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e3254ce9dc5ecf6d61ef83264bc61d486a307f0e3c9ed1bb2176f068cdbcbe09
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDSingleApplication_QT6=ON
"
