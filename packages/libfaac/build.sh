TERMUX_PKG_HOMEPAGE=http://faac.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Freeware Advanced Audio Coder AAC Enoder"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE=GPL-2.0
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_VERSION=1.29.9.2
_VERSION_REAL=$(cut -f1,2 -d '.' <<< ${TERMUX_PKG_VERSION})
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/faac/files/faac-src/faac-${_VERSION_REAL}/faac-${TERMUX_PKG_VERSION}.tar.gz/download
TERMUX_PKG_SHA256=d45f209d837c49dae6deebcdd87b8cc3b04ea290880358faecf5e7737740c771
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--build=aarch64-unknown-linux-gnu"
