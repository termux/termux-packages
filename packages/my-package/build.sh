termux_step_make_install() {
    install -Dm755 $TERMUX_PKG_BUILDER_DIR/myscript.sh $TERMUX_PREFIX/bin/myscript
}
