TERMUX_PKG_HOMEPAGE=https://the.exa.website
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.0-git
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ogham/exa/archive/39c8c67bf6237076b24915851f908d6da13c04b7.tar.gz
TERMUX_PKG_SHA256=e3fba517f0017e6a7435421d63e73c4e695f2844433d8245debb0f51b89a5a9e
TERMUX_PKG_DEPENDS="zlib, libgit2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	CFLAGS="$CPPFLAGS"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	mkdir -p $TERMUX_PREFIX/share/man/man5
	pandoc --standalone --to man $TERMUX_PKG_SRCDIR/man/exa.1.md --output $TERMUX_PREFIX/share/man/man1/exa.1
  	pandoc --standalone --to man $TERMUX_PKG_SRCDIR/man/exa_colors.5.md --output $TERMUX_PREFIX/share/man/man5/exa_colors.5
}
