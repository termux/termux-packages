TERMUX_PKG_HOMEPAGE=http://termux.com
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_VERSION=0.2

termux_step_make_install () {
	TERMUX_SHARE_DIR=$TERMUX_PREFIX/share/termux
	mkdir -p $TERMUX_SHARE_DIR
	cp $TERMUX_PKG_BUILDER_DIR/commands.txt $TERMUX_SHARE_DIR/commands.txt

	TERMUX_LIBEXEC_DIR=$TERMUX_PREFIX/libexec/termux
	mkdir -p $TERMUX_LIBEXEC_DIR
	$CC $CFLAGS $LDFLAGS -std=c11 $TERMUX_PKG_BUILDER_DIR/command-not-found.c \
	        -DTERMUX_COMMANDS_LISTING=$TERMUX_PREFIX/share/termux/commands.txt \
	        -o $TERMUX_LIBEXEC_DIR/command-not-found
}
