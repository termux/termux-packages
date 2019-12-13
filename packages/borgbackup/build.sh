TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.1.10
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=efb41416d24ff1d13c7952c7f4eaf41ef6fc5e1000354217db55cd62c905e7de
TERMUX_PKG_DEPENDS="libacl,liblz4,zstd,openssl,python"
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/python3.8/site-packages/easy-install.pth
lib/python3.8/site-packages/site.py
"

termux_step_make_install () {
  export PYTHONPATH=$TERMUX_PREFIX/lib/python3.8/site-packages
  export CPPFLAGS+=" -I$TERMUX_PREFIX/include/python3.8"
  export LDFLAGS+=" -lpython3.8"
  export LDSHARED="$CC -shared"
  export BORG_OPENSSL_PREFIX=$TERMUX_PREFIX
  export BORG_LIBLZ4_PREFIX=$TERMUX_PREFIX
  export BORG_LIBZSTD_PREFIX=$TERMUX_PREFIX
  python3.8 setup.py install --prefix=$TERMUX_PREFIX --force
}
