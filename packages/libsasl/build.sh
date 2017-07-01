TERMUX_PKG_HOMEPAGE=http://asg.web.cmu.edu/sasl/
TERMUX_PKG_DESCRIPTION="Cyrus SASL - authentication abstraction library"
TERMUX_PKG_VERSION=2.1.26
TERMUX_PKG_SRCURL=ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8fbc5136512b59bb793657f36fadda6359cae3b08f01fd16b3d406f1345b7bc3
# Seems to be race issues in build (symlink creation)::
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" ac_cv_func_syslog=no ac_cv_header_syslog_h=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-des --disable-otp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-plugindir=$TERMUX_PREFIX/lib/sasl2 --sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-dblib=none"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-dbpath=$TERMUX_PREFIX/var/lib/sasldb --with-saslauthd=$TERMUX_PREFIX/var/run/saslauthd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-saslauthd"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pluginviewer"

termux_step_post_configure () {
	# Build wants to run makemd5 at build time:
	gcc $TERMUX_PKG_SRCDIR/include/makemd5.c -o $TERMUX_PKG_BUILDDIR/include/makemd5
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/include/makemd5
}
