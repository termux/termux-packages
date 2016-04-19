TERMUX_PKG_HOMEPAGE=http://termux.com/add-ons/api/
TERMUX_PKG_DESCRIPTION="Termux API commands"
TERMUX_PKG_VERSION=0.16

termux_step_make_install () {
        mkdir -p $TERMUX_PREFIX/bin
	local TERMUX_API_BINARY=$TERMUX_PREFIX/libexec/termux-api
	cd $TERMUX_PKG_BUILDER_DIR
        for file in `ls termux-* | grep -v termux-api.c`; do
		sed "s|@TERMUX_API@|$TERMUX_API_BINARY|" $file > $TERMUX_PREFIX/bin/$file
		chmod +x $TERMUX_PREFIX/bin/$file
        done
        $CC $CFLAGS -std=c11 -Wall -Wextra -pedantic -Werror $LDFLAGS termux-api.c -o $TERMUX_API_BINARY
}
