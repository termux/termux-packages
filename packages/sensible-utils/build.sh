TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/sensible-utils
TERMUX_PKG_DESCRIPTION="Small utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.24"
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/s/sensible-utils/sensible-utils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=620602b900bad2b9856556a7895ea146110f602cd526a1cc03068a0bc9542803
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_prog_PO4A=/bin/echo"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
