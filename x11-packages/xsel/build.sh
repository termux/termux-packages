TERMUX_PKG_HOMEPAGE=http://www.kfish.org/software/xsel/
TERMUX_PKG_DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Doron Behar <me@doronbehar.com>"
TERMUX_PKG_VERSION=1.2.0.20190505
TERMUX_PKG_REVISION=23
_COMMIT=24bee9c7f4dc887eabb2783f21cbf9734d723d72
TERMUX_PKG_SRCURL=https://github.com/kfish/xsel/archive/24bee9c7f4dc887eabb2783f21cbf9734d723d72.zip
TERMUX_PKG_SHA256=9b9b92deece971201d75b8932a743e8a6b597c4b146de193f54d09a58da15624
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="libxt"

termux_step_pre_configure() {
	autoreconf -fi
}
