TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/zoxide
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.9
TERMUX_PKG_SRCURL=https://github.com/ajeetdsouza/zoxide/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=aea1a55d107a2367d46be19617fbd8fb440d906121a84d6d9e7b86f3a24fbad4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f ./Makefile
}

termux_step_post_make_install() {
	# Install man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/man/* $TERMUX_PREFIX/share/man/man1/
}
