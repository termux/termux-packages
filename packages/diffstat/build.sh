TERMUX_PKG_HOMEPAGE=https://invisible-island.net/diffstat/diffstat.html
TERMUX_PKG_DESCRIPTION="Displays a histogram of changes to a file"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.65
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ThomasDickey/diffstat-snapshots/archive/refs/tags/v${TERMUX_PKG_VERSION/./_}.tar.gz
# invisible-mirror.net is not suitable for CI due to bad responsiveness.
#TERMUX_PKG_SRCURL=https://invisible-mirror.net/archives/diffstat/diffstat-${TERMUX_PKG_VERSION}.tgz
#TERMUX_PKG_SRCURL=https://invisible-island.net/datafiles/release/diffstat.tar.gz
TERMUX_PKG_SHA256=7198e0f1ee6b95fb6ef7b6b0dfbeba2761abfb143ab1b57343859eeba4172ffc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
