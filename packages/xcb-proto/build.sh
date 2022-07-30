# X11 package
TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="XML-XCB protocol descriptions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.15
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d34c3b264e8365d16fa9db49179cfa3e9952baaf9275badda0f413966b65955f
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFLICTS="xcbproto"
TERMUX_PKG_REPLACES="xcbproto"

termux_step_pre_configure() {
	export PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	export PYTHON=python$PYTHON_VERSION
	TERMUX_PKG_RM_AFTER_INSTALL="lib/${PYTHON}/site-packages/xcbgen/__pycache__"
}
