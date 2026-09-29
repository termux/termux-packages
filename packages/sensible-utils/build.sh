TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/sensible-utils
TERMUX_PKG_DESCRIPTION="Small utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.26"
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/s/sensible-utils/sensible-utils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=46adb7a12d32a9323b29711bc6470628fcc0f94f1748fe5bae4729df50531f68
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_prog_PO4A=/bin/echo"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
