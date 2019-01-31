TERMUX_PKG_HOMEPAGE=https://termux.com/
TERMUX_PKG_DESCRIPTION="Service daemon for Termux"
TERMUX_PKG_VERSION=0.01
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
    cp -p $TERMUX_PKG_BUILDER_DIR/termux-services $TERMUX_PREFIX/bin/
    mkdir -p $TERMUX_PREFIX/etc/profile.d/
    cp -p $TERMUX_PKG_BUILDER_DIR/start-services.sh $TERMUX_PREFIX/etc/profile.d/
}
