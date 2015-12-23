# HEAVILY adapted from archlinux PKGBUILD
pkgname=pacman
pkgver=4.2.1

TERMUX_PKG_HOMEPAGE=https://www.archlinux.org/pacman/
TERMUX_PKG_DESCRIPTION="A library-based package manager with dependency support"
TERMUX_PKG_VERSION=$pkgver

TERMUX_PKG_DEPENDS="bash glibc libarchive curl gpgme asciidoc python2 fakechroot"

TERMUX_PKG_SRCURL="https://sources.archlinux.org/other/pacman/$pkgname-$pkgver.tar.gz"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_MAINTAINER="Francisco Demartino <demartino.francisco@gmail.com>"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$TERMUX_PREFIX/usr --sysconfdir=$TERMUX_PREFIX/usr/etc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --localstatedir=$TERMUX_PREFIX/usr/var --enable-doc "
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-scriptlet-shell=/usr/bin/bash"

termux_step_make () {
  make
  make -C contrib
  make -C "$pkgname-$pkgver" check
}

#package() {
termux_step_make_install () {

  make DESTDIR="$TERMUX_PREFIX" install
  make DESTDIR="$TERMUX_PREFIX" -C contrib install

  # install Arch specific stuff
  install -dm755 "$TERMUX_PREFIX/usr/etc"
  install -m644 "pacman.conf" "$TERMUX_PREFIX/usr/etc/pacman.conf"

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
  install -m644 "makepkg.conf" "$TERMUX_PREFIX/usr/etc"
  sed -i "$TERMUX_PREFIX/usr/etc/makepkg.conf" \
    -e "s|@CARCH[@]|$mycarch|g" \
    -e "s|@CHOST[@]|$mychost|g" \
    -e "s|@CARCHFLAGS[@]|$myflags|g"

  # put bash_completion in the right location
  install -dm755 "$TERMUX_PREFIX/usr/share/bash-completion/completions"
  mv "$TERMUX_PREFIX/usr/etc/bash_completion.d/pacman" "$TERMUX_PREFIX/usr/share/bash-completion/completions"
  rmdir "$TERMUX_PREFIX/usr/etc/bash_completion.d"

  for f in makepkg pacman-key; do
    ln -s pacman "$TERMUX_PREFIX/usr/share/bash-completion/completions/$f"
  done

  install -Dm644 contrib/PKGBUILD.vim "$TERMUX_PREFIX/usr/share/vim/vimfiles/syntax/PKGBUILD.vim"
}
