TERMUX_PKG_HOMEPAGE=https://github.com/zlin/wgetpaste
TERMUX_PKG_DESCRIPTION="wgetpaste is a shell script that allows its users to upload log."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.34"
TERMUX_PKG_SRCURL=https://github.com/zlin/wgetpaste/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=097b77440460365976f8f66e99b0150c8a9527307f6ecade1db6b60a0bfad781
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="wget"
TERMUX_PKG_SUGGESTS="xclip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
termux_step_make_install() {
	install -Dm 755 -t "$TERMUX_PREFIX/bin" wgetpaste
	install -Dm644 _wgetpaste $TERMUX_PREFIX/share/zsh/site-functions/_wgetpaste
}
