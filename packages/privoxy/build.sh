TERMUX_PKG_HOMEPAGE=https://www.privoxy.org
TERMUX_PKG_DESCRIPTION="Privoxy is a non-caching web proxy with advanced filtering capabilities"
TERMUX_PKG_VERSION=3.0.26
TERMUX_PKG_SRCURL=https://www.privoxy.org/sf-download-mirror/Sources/$TERMUX_PKG_VERSION%20%28stable%29/privoxy-$TERMUX_PKG_VERSION-stable-src.tar.gz
TERMUX_PKG_FOLDERNAME=privoxy-$TERMUX_PKG_VERSION-stable
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dynamic-pcre --sysconfdir=$TERMUX_PREFIX/etc/privoxy"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    autoheader
    autoconf

    # avoid 'aarch64-linux-android-strip': No such file or directory
    ln -s $TERMUX_STANDALONE_TOOLCHAIN/bin/$STRIP .
}

termux_step_post_make_install() {
    # delete link created to avoid errors
    rm -f $TERMUX_PREFIX/sbin/$STRIP
}

