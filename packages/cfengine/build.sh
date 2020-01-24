TERMUX_PKG_HOMEPAGE=https://cfengine.com/
TERMUX_PKG_DESCRIPTION="CFEngine is a configuration management technology."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.15.1
TERMUX_PKG_SRCURL=(https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-$TERMUX_PKG_VERSION.tar.gz
                   https://github.com/cfengine/masterfiles/archive/$TERMUX_PKG_VERSION.tar.gz)
TERMUX_PKG_SHA256=(ab597456f9d44d907bb5a2e82b8ce2af01e9c59641dc828457cd768ef05a831d
                   1da37b8af293f5c072ed6991f4bb910cc2b387038e4dc7c34ae1763515b558e1)
TERMUX_PKG_DEPENDS="liblmdb, openssl, libandroid-glob, pcre"
# core doesn't work with out-of-tree builds
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-workdir=$TERMUX_PREFIX/var/lib/cfengine --without-pam --without-selinux-policy --without-systemd-service --with-lmdb=$TERMUX_PREFIX --with-openssl=$TERMUX_PREFIX --with-pcre=$TERMUX_PREFIX"

termux_step_post_extract_package() {
  cd masterfiles-${TERMUX_PKG_VERSION}
  EXPLICIT_VERSION=${TERMUX_PKG_VERSION} ./autogen.sh --prefix=$TERMUX_PREFIX/var/lib/cfengine --bindir=$TERMUX_PREFIX/bin
  make install
}

termux_step_pre_configure() {
  LDFLAGS+=" -landroid-glob"
}
