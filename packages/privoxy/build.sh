TERMUX_PKG_HOMEPAGE=https://www.privoxy.org
TERMUX_PKG_DESCRIPTION="Privoxy is a non-caching web proxy with advanced filtering capabilities"
TERMUX_PKG_VERSION=3.0.24
TERMUX_PKG_SRCURL=https://www.privoxy.org/sf-download-mirror/Sources/$TERMUX_PKG_VERSION%20%28stable%29/privoxy-$TERMUX_PKG_VERSION-stable-src.tar.gz
TERMUX_PKG_FOLDERNAME=privoxy-$TERMUX_PKG_VERSION-stable
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dynamic-pcre --sysconfdir=$TERMUX_PREFIX/etc/privoxy"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    autoheader
    autoconf

    # avoid 'aarch64-linux-android-strip': No such file or directory
    ln -s $TERMUX_STANDALONE_TOOLCHAIN/bin/$TERMUX_ARCH-linux-android-strip .
}

termux_step_post_make_install() {
    # delete link created to avoid errors
    rm -f $TERMUX_PREFIX/sbin/$TERMUX_ARCH-linux-android-strip
}

termux_step_post_massage() {
    # remove ".new" from default config files
    mv ./etc/privoxy/config.new ./etc/privoxy/config
    mv ./etc/privoxy/match-all.action.new ./etc/privoxy/match-all.action
    mv ./etc/privoxy/trust.new ./etc/privoxy/trust
    mv ./etc/privoxy/user.action.new ./etc/privoxy/user.action
    mv ./etc/privoxy/user.filter.new ./etc/privoxy/user.filter
}