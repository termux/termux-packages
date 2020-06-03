TERMUX_PKG_HOMEPAGE=https://cfengine.com/
TERMUX_PKG_DESCRIPTION="CFEngine is a configuration management technology."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.15.2
TERMUX_PKG_SRCURL=(https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.2.tar.gz
                   https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.2.tar.gz)
TERMUX_PKG_SHA256=(d1c570b7a0f47794a92f66e21cccdc86b8f56a7028a389780e705db41bfd3cab
                   932d882cb6231db0cd9cfcaa8a0130e069355bc1a7307f8038ababd1320d99a8)
TERMUX_PKG_DEPENDS="liblmdb, openssl, libandroid-glob, pcre"
# core doesn't work with out-of-tree builds
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-workdir=$TERMUX_PREFIX/var/lib/cfengine --without-pam --without-selinux-policy --without-systemd-service --with-lmdb=$TERMUX_PREFIX --with-openssl=$TERMUX_PREFIX --with-pcre=$TERMUX_PREFIX"

termux_step_post_extract_package() {
  cd cfengine-masterfiles-${TERMUX_PKG_VERSION}
  EXPLICIT_VERSION=${TERMUX_PKG_VERSION} ./configure --prefix=$TERMUX_PREFIX/var/lib/cfengine --bindir=$TERMUX_PREFIX/bin
  make install
}

termux_step_pre_configure() {
  LDFLAGS+=" -landroid-glob"
}
