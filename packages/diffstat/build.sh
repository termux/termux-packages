TERMUX_PKG_HOMEPAGE=https://invisible-island.net/diffstat/diffstat.html
TERMUX_PKG_DESCRIPTION="Displays a histogram of changes to a file"
TERMUX_PKG_LICENSE="HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.68"
TERMUX_PKG_SRCURL=https://github.com/ThomasDickey/diffstat-snapshots/archive/refs/tags/v${TERMUX_PKG_VERSION/./_}.tar.gz
# invisible-mirror.net is not suitable for CI due to bad responsiveness.
#TERMUX_PKG_SRCURL=https://invisible-mirror.net/archives/diffstat/diffstat-${TERMUX_PKG_VERSION}.tgz
#TERMUX_PKG_SRCURL=https://invisible-island.net/datafiles/release/diffstat.tar.gz
TERMUX_PKG_SHA256=1a4d60b630e120c9e1213112be2c52f6ba757ae09cb39273ecd39653c450aef8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
