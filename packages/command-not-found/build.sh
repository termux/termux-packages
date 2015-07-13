TERMUX_PKG_HOMEPAGE=http://termux.com
TERMUX_PKG_DESCRIPTION="List of commands available for installation"
TERMUX_PKG_VERSION=0.1

termux_step_make_install () {
	TERMUX_SHARE_DIR=$TERMUX_PREFIX/share/termux
	mkdir -p $TERMUX_SHARE_DIR
	cp $TERMUX_PKG_BUILDER_DIR/commands.txt $TERMUX_SHARE_DIR/commands.txt
}
