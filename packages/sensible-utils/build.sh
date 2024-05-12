TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/sensible-utils
TERMUX_PKG_DESCRIPTION="Small utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.22"
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/s/sensible-utils/sensible-utils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c744d604ad6e1f3c8b4831cd84d653cf86bf9867a856724bf3f4fceb2de215b5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_prog_PO4A=/bin/echo"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
