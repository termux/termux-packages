TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/sensible-utils
TERMUX_PKG_DESCRIPTION="Small utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.23"
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/s/sensible-utils/sensible-utils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0de5526c06f7c41b2f3d68eba570d08ffc7c2883c567d9786eaf25d9e554d4d6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_prog_PO4A=/bin/echo"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
