TERMUX_PKG_HOMEPAGE=https://github.com/Dess-Services/dess-repo
TERMUX_PKG_DESCRIPTION="Professional metadata generator and binary validator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Dess-Services <dessservicesofc@gmail.com>"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="coreutils, openssl-tool, ncurses-utils"

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/bin
    cp $TERMUX_PKG_BUILDER_DIR/dmeta $TERMUX_PREFIX/bin/dmeta
    chmod +x $TERMUX_PREFIX/bin/dmeta
}
