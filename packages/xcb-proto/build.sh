# X11 package
TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="XML-XCB protocol descriptions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=2c1bacd2110f4799f74de6ebb714b94cf6f80fb112316b1219480fd22562148c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFLICTS="xcbproto"
TERMUX_PKG_REPLACES="xcbproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PYTHON=/usr/bin/python3
am_cv_python_pythondir=$TERMUX_PYTHON_HOME/site-packages
"

termux_step_post_make_install() {
	# We are using Ubuntu's host python for installing the package which may be of
	# different major version. Python bytecode isn't compatible across versions.
	# So get rid of it
	rm -r "$TERMUX_PREFIX/lib/python3.13/site-packages/xcbgen/__pycache__/"
}
