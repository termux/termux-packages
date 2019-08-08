TERMUX_PKG_HOMEPAGE=https://www.privoxy.org
TERMUX_PKG_DESCRIPTION="Non-caching web proxy with advanced filtering capabilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.0.28
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=b5d78cc036aaadb3b7cf860e9d598d7332af468926a26e2d56167f1cb6f2824a
TERMUX_PKG_SRCURL=https://www.privoxy.org/sf-download-mirror/Sources/$TERMUX_PKG_VERSION%20%28stable%29/privoxy-$TERMUX_PKG_VERSION-stable-src.tar.gz
TERMUX_PKG_CONFFILES='etc/privoxy/config etc/privoxy/match-all.action etc/privoxy/trust etc/privoxy/user.action etc/privoxy/user.filter etc/privoxy/default.action etc/privoxy/default.filter'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pcreposix_regcomp=no
--sysconfdir=$TERMUX_PREFIX/etc/privoxy
"
TERMUX_PKG_DEPENDS="pcre, libpcreposix, zlib"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

    autoheader
    autoconf

    # avoid 'aarch64-linux-android-strip': No such file or directory
    ln -s "$TERMUX_STANDALONE_TOOLCHAIN/bin/$STRIP" .
}

termux_step_post_make_install() {
    # delete link created to avoid errors
    rm -f "$TERMUX_PREFIX/sbin/$STRIP"
}

termux_step_post_massage() {
    # copy default config files
    for f in $TERMUX_PKG_CONFFILES; do
	cp "$TERMUX_PKG_SRCDIR/$(basename $f)" "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$f"
    done
}
