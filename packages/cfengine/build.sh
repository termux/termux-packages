TERMUX_PKG_HOMEPAGE=https://cfengine.com/
TERMUX_PKG_DESCRIPTION="CFEngine is a configuration management technology."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@cfengine"
TERMUX_PKG_VERSION=1:3.17.0
TERMUX_PKG_SRCURL=(https://github.com/cfengine/core/archive/${TERMUX_PKG_VERSION:2}.zip
                   https://github.com/cfengine/masterfiles/archive/49b253224c5c2eb375864c9fe8145a5d1a353e00.zip
                   https://github.com/cfengine/libntech/archive/4e9efcb84172110fa92742836b8d34688983c2e7.zip)
TERMUX_PKG_SHA256=(55ea8e0f2e3d1cd8cee80d164c0f6d33be7bb7ac8661d74ce6c26d68e4a3967f
                   88fb3fb493659822dda6c0e0c5a4a102bbdcfc9a9db5d430af97e00b2eccde5f
                   0731930c0eaca887be3c80bb6615c39bf824b6e6b8c4a241da41740c013dc5e4)
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
  EXPLICIT_VERSION=${TERMUX_PKG_VERSION:2}
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
