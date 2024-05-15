TERMUX_PKGHOMEPAGE=https://gist.github.com/DevMasterLinux/ba96cfb7ec6b7e0960f400a1b0d80a24
TERMUX_PKG_DESCRIPTION="A Tool to Switch the Package Manager fast and safe"
TERMUX_PKG_MAINTAINER="@DevMasterLinux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="1.0"

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/bin
    cp $TERMUX_PKG_BUILDER_DIR/termux-switch-manager $TERMUX_PREFIX/bin/
    cp $TERMUX_PKG_BUILDER_DIR/LICENSE $TERMUX_PREFIX/share/doc/termux-switch-manager/
}


termux_step_create_debscripts() {
	return 0
}
