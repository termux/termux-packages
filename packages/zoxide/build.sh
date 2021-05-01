TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/zoxide
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/ajeetdsouza/zoxide/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e9d97ce48f67ebcb99d4a880789128a79634573f48e8402b053f0c833ddcbca8
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
  # Install man page:
  mkdir -p $TERMUX_PREFIX/share/man/man1/
  cp $TERMUX_PKG_SRCDIR/man/* $TERMUX_PREFIX/share/man/man1/
}
