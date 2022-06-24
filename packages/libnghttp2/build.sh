TERMUX_PKG_HOMEPAGE=https://nghttp2.org/
TERMUX_PKG_DESCRIPTION="nghttp HTTP 2.0 library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.48.0"
TERMUX_PKG_SRCURL=https://github.com/nghttp2/nghttp2/releases/download/v${TERMUX_PKG_VERSION}/nghttp2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=47d8f30ee4f1bc621566d10362ca1b3ac83a335c63da7144947c806772d016e4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libnghttp2-dev"
TERMUX_PKG_REPLACES="libnghttp2-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-lib-only"
# The tools are not built due to --enable-lib-only:
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1 share/nghttp2/fetch-ocsp-response"
