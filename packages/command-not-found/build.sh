TERMUX_PKG_HOMEPAGE=https://termux.com
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.40
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make_install() {
	TERMUX_LIBEXEC_DIR=$TERMUX_PREFIX/libexec/termux
	mkdir -p $TERMUX_LIBEXEC_DIR
	$CXX -Wall -Wextra -Werror -pedantic $CFLAGS $LDFLAGS -std=c++11 $TERMUX_PKG_BUILDER_DIR/command-not-found.cpp \
		-o $TERMUX_LIBEXEC_DIR/command-not-found
}
