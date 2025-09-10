TERMUX_PKG_HOMEPAGE=https://github.com/devnev/libxdg-basedir
TERMUX_PKG_DESCRIPTION="An implementation of the XDG Base Directory specifications"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff30c60161f7043df4dcc6e7cdea8e064e382aa06c73dcc3d1885c7d2c77451d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

termux_step_pre_configure() {
	autoreconf -fi
}
