TERMUX_PKG_HOMEPAGE=https://github.com/zlin/wgetpaste
TERMUX_PKG_DESCRIPTION="wgetpaste is a shell script that allows its users to upload log."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.33
TERMUX_PKG_SRCURL=https://github.com/zlin/wgetpaste/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b32a283c84dc7b35b3a803ac330c7f13a2faef404809139e3ac5fca7a44bba3e
TERMUX_PKG_DEPENDS="wget"
TERMUX_PKG_SUGGESTS="xclip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
termux_step_make_install() {
	install -Dm 755 -t "$TERMUX_PREFIX/bin" wgetpaste
	install -Dm644 _wgetpaste $TERMUX_PREFIX/share/zsh/site-functions/_wgetpaste
}
