TERMUX_PKG_HOMEPAGE=https://github.com/Dess-Services/dess-repo
TERMUX_PKG_DESCRIPTION="DESS-STATION Security Suite - Advanced encryption and integrity tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Dess-Services <dessservicesofc@gmail.com>"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_SRCURL=https://github.com/Dess-Services/dess-repo/archive/refs/tags/v3.2.tar.gz
TERMUX_PKG_SHA256=d33f4b4106d6d8f3676f1047dd735b7091a5279fb5d24c6f9924984b64f36a87
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/bin
    install -m 755 $TERMUX_PKG_SRCDIR/dap $TERMUX_PREFIX/bin/dap
    install -m 755 $TERMUX_PKG_SRCDIR/dmeta $TERMUX_PREFIX/bin/dmeta
    install -m 755 $TERMUX_PKG_SRCDIR/dap-error-info $TERMUX_PREFIX/bin/dap-error-info
}
# Technical update for CI trigger
