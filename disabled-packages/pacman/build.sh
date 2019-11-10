TERMUX_PKG_HOMEPAGE=https://www.archlinux.org/pacman/
TERMUX_PKG_DESCRIPTION="A library-based package manager with dependency support"
TERMUX_PKG_MAINTAINER="Francisco Demartino @franciscod"
# HEAVILY adapted from archlinux PKGBUILD
pkgname=pacman
pkgver=4.2.1
TERMUX_PKG_VERSION=$pkgver
#FIXME: asciidoc, fakechroot/fakeroot
TERMUX_PKG_DEPENDS="bash, glib, libarchive, curl, gpgme, python2, libandroid-glob, libandroid-support"
TERMUX_PKG_SRCURL="https://sources.archlinux.org/other/pacman/$pkgname-$pkgver.tar.gz"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$TERMUX_PREFIX --sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --localstatedir=$TERMUX_PREFIX/var --enable-doc "
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-scriptlet-shell=/usr/bin/bash"

termux_step_pre_configure() {
  LDFLAGS+="$LDFLAGS -llog -landroid-glob"
}

termux_step_make() {
  make
  make -C contrib
  # make -C "$pkgname-$pkgver" check
}

termux_step_make_install() {

  make install
  make -C contrib install

  # install Arch specific stuff
  install -dm755 "$TERMUX_PREFIX/etc"
  install -m644 "$TERMUX_PKG_BUILDER_DIR/pacman.conf" "$TERMUX_PREFIX/etc/pacman.conf"

  case $TERMUX_ARCH in
    i686)
      mycarch="i686"
      mychost="i686-pc-linux-gnu"
      myflags="-march=i686"
      ;;
    arm)
      mycarch="arm"
      mychost="arm-unknown-linux-gnu"
      myflags="-march=arm"
      ;;
  esac

  # set things correctly in the default conf file
  install -m644 "$TERMUX_PKG_BUILDER_DIR/makepkg.conf" "$TERMUX_PREFIX/etc"
  sed -i "$TERMUX_PREFIX/etc/makepkg.conf" \
    -e "s|@CARCH[@]|$mycarch|g" \
    -e "s|@CHOST[@]|$mychost|g" \
    -e "s|@CARCHFLAGS[@]|$myflags|g"

  # FIXME bash_completion
  # # put bash_completion in the right location
  # install -dm755 "$TERMUX_PREFIX/share/bash-completion/completions"
  # mv "$TERMUX_PREFIX/etc/bash_completion.d/pacman" "$TERMUX_PREFIX/share/bash-completion/completions"
  # rmdir "$TERMUX_PREFIX/etc/bash_completion.d"

  # for f in makepkg pacman-key; do
  #   ln -s pacman "$TERMUX_PREFIX/share/bash-completion/completions/$f"
  # done

  install -Dm644 contrib/PKGBUILD.vim "$TERMUX_PREFIX/share/vim/vimfiles/syntax/PKGBUILD.vim"
}
