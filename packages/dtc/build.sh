TERMUX_PKG_HOMEPAGE=https://git.kernel.org/pub/scm/utils/dtc/dtc
TERMUX_PKG_DESCRIPTION="Device Tree Compiler"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_SRCURL=https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=74b50bb19134f6562490afea53e59953dd6c4afb17e5ccb60be32221262d3390
TERMUX_PKG_BREAKS="dtc-dev, qemu-common (<< 1:8.2.5-2), qemu-system-x86-64 (<< 1:8.2.5-3)"
TERMUX_PKG_REPLACES="dtc-dev, qemu-common (<< 1:8.2.5-2), qemu-system-x86-64 (<< 1:8.2.5-3)"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dtools=true
"
