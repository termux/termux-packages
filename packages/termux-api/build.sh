TERMUX_PKG_HOMEPAGE=http://termux.com/add-ons/api/
TERMUX_PKG_DESCRIPTION="Termux API commands"
TERMUX_PKG_VERSION=0.4.49

termux_step_make_install () {
        mkdir -p $TERMUX_PREFIX/bin
        for file in `ls $TERMUX_PKG_BUILDER_DIR/* | grep -v build.sh | grep -v termux-api.c`; do
		cp $file $TERMUX_PREFIX/bin
        done
        $CC $CFLAGS -std=c11 -Wall -Wextra $LDFLAGS $TERMUX_PKG_BUILDER_DIR/termux-api.c -o $TERMUX_PREFIX/bin/termux-api
}
