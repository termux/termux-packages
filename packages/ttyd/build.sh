TERMUX_PKG_HOMEPAGE=https://tsl0922.github.io/ttyd/
TERMUX_PKG_DESCRIPTION="Command-line tool for sharing terminal over the web"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SHA256=ff1a66b418df6cd741868a8ea84f69cd63f15e52e3fa117641ec57d3c37a1315
TERMUX_PKG_SRCURL=https://github.com/tsl0922/ttyd/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="json-c, libwebsockets, libutil"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_XXD=`which xxd`"
