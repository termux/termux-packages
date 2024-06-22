TERMUX_PKG_HOMEPAGE=http://xmlsoft.org/libxslt/
TERMUX_PKG_DESCRIPTION="XSLT processing library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.40"
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/GNOME/libxslt/-/archive/v${TERMUX_PKG_VERSION}/libxslt-v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c4df0a29fa5dba8c557be71ab00f9744cfb46f1fa9d2d5c6d616e3781250e87d
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIBXSLT_WITH_PYTHON=no"
TERMUX_PKG_DEPENDS="libgcrypt, libgpg-error, libxml2, libandroid-glob"
TERMUX_PKG_BREAKS="libxslt-dev"
TERMUX_PKG_REPLACES="libxslt-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
