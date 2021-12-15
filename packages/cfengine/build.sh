TERMUX_PKG_HOMEPAGE=https://cfengine.com/
TERMUX_PKG_DESCRIPTION="CFEngine is a configuration management technology."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@craigcomstock"
TERMUX_PKG_VERSION=1:3.18.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=(https://github.com/cfengine/core/archive/${TERMUX_PKG_VERSION:2}.zip
                   https://github.com/cfengine/masterfiles/archive/12b52c25e03439341aa7a6a5c7917efa06826f8d.zip
                   https://github.com/cfengine/libntech/archive/118d6e4bf5ae2611236fe3883b422d50f10da45c.zip)
TERMUX_PKG_SHA256=(846f4cf2a6154817c730b847cacc6f9aacd32c51abc00c137f56650d85e47134
                   9372e0c65322dc85c5f6f95be175ac0858c94d5ffb54317e8e332ddac634657a
                   49e03c1daf913bbe370a56aac03b0d2a7250d108c91b39780487304b3e6ac047)
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
  export EXPLICIT_VERSION=${TERMUX_PKG_VERSION:2}
  export LDFLAGS+=" -landroid-glob"
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
