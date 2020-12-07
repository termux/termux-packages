# X11 package
TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="XML-XCB protocol descriptions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.14.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f04add9a972ac334ea11d9d7eb4fc7f8883835da3e4859c9afa971efdf57fcc3
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFLICTS="xcbproto"
TERMUX_PKG_REPLACES="xcbproto"

termux_step_pre_configure() {
	python_version=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	TERMUX_PKG_RM_AFTER_INSTALL="lib/python${python_version}/site-packages/xcbgen/__pycache__"
}
