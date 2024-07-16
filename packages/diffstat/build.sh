TERMUX_PKG_HOMEPAGE=https://invisible-island.net/diffstat/diffstat.html
TERMUX_PKG_DESCRIPTION="Displays a histogram of changes to a file"
TERMUX_PKG_LICENSE="HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.66"
TERMUX_PKG_SRCURL=https://github.com/ThomasDickey/diffstat-snapshots/archive/refs/tags/v${TERMUX_PKG_VERSION/./_}.tar.gz
# invisible-mirror.net is not suitable for CI due to bad responsiveness.
#TERMUX_PKG_SRCURL=https://invisible-mirror.net/archives/diffstat/diffstat-${TERMUX_PKG_VERSION}.tgz
#TERMUX_PKG_SRCURL=https://invisible-island.net/datafiles/release/diffstat.tar.gz
TERMUX_PKG_SHA256=51570ed05b8c13ca2163ce301fc1418545baf05881e18bcd21e4af5ff1bd14eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
