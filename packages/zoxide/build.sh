TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/zoxide
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL=https://github.com/ajeetdsouza/zoxide/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7af5965e0f0779a5ea9135ee03c51b1bb1d84b578af0a7eb2bd13dbf34a342dd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f ./Makefile
}

termux_step_post_make_install() {
	# Install man page:
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1/
	cp -r $TERMUX_PKG_SRCDIR/man/* $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1/
}
