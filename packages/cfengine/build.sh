TERMUX_PKG_HOMEPAGE=https://cfengine.com/
TERMUX_PKG_DESCRIPTION="CFEngine is a configuration management technology."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.17.0a1-termux
TERMUX_PKG_SRCURL=(https://github.com/cfengine/core/archive/ec47889f4bef53c6c5a15add60d34c44c6ef1634.zip
                   https://github.com/cfengine/masterfiles/archive/83c4e0cf9dddffdd192d49f98a30a9bb705edfc4.zip
                   https://github.com/cfengine/libntech/archive/10f1112b118b05cf9ccc2aedcf4b1ee09090fcd0.zip)
TERMUX_PKG_SHA256=(53feaf799db0ac7e9579f7101c1ab87dc9bba7e383f3da1a74828e4a6dc005e1
                   3ea7759125acc6501c49ba58f98cef9cea598f5da810352eda86e1efa4d19b8e
                   b0458087ab526b5b73bc9e399e420dcef31d4e649898954346f8bd2594bd9446)
TERMUX_PKG_DEPENDS="liblmdb, openssl, libandroid-glob, pcre, libyaml, libxml2"
# core doesn't work with out-of-tree builds
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-workdir=$TERMUX_PREFIX/var/lib/cfengine --without-pam --without-selinux-policy --without-systemd-service --with-lmdb=$TERMUX_PREFIX --with-openssl=$TERMUX_PREFIX --with-yaml=$TERMUX_PREFIX --with-pcre=$TERMUX_PREFIX --with-prefix=$TERMUX_PREFIX --with-libxml2=$TERMUX_PREFIX"

termux_step_post_get_source() {
  # commit-based zips from github include the commit sha so rename to normalize for later steps
  mv masterfiles-* masterfiles
  rm -rf libntech
  mv libntech-* libntech
}

termux_step_pre_configure() {
  EXPLICIT_VERSION=${TERMUX_PKG_VERSION}
  LDFLAGS+=" -landroid-glob"
  NO_CONFIGURE=1 ./autogen.sh $TERMUX_PKG_EXTRA_CONFIGURE_ARGS --prefix=$TERMUX_PREFIX/var/lib/cfengine --bindir=$TERMUX_PREFIX/bin

  cd masterfiles
  ./autogen.sh --prefix=$TERMUX_PREFIX/var/lib/cfengine --bindir=$TERMUX_PREFIX/bin
  make install
}

termux_step_create_debscripts() {
        cat << EOF > ./postinst
        #!$TERMUX_PREFIX/bin/sh
        # Generate a host key
        if [ ! -f $TERMUX_PREFIX/var/lib/cfengine/ppkeys/localhost.priv ]; then
          $TERMUX_PREFIX/bin/cf-key >/dev/null || :
        fi
EOF
}
