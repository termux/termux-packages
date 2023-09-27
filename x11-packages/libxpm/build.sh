TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 pixmap library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.16
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXpm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e6bc5da7a69dbd9bcc67e87c93d4904fe2f5177a0711c56e71fa2f6eff649f51
TERMUX_PKG_DEPENDS="libx11, libxext, libxt"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_XPM_PATH_COMPRESS=$TERMUX_PREFIX/bin/compress
ac_cv_path_XPM_PATH_UNCOMPRESS=$TERMUX_PREFIX/bin/uncompress
ac_cv_path_XPM_PATH_GZIP=$TERMUX_PREFIX/bin/gzip
"
