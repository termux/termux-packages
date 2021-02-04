TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/sensible-utils
TERMUX_PKG_DESCRIPTION="Small utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.14
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/s/sensible-utils/sensible-utils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a6ee528bf4122d77acacdb97f20cd0434a12ad3ecd119186a5fcee066844c644
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_prog_PO4A=/bin/echo"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
