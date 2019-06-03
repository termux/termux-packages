TERMUX_PKG_HOMEPAGE=https://www.cyrusimap.org/sasl/
TERMUX_PKG_DESCRIPTION="Cyrus SASL - authentication abstraction library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.1.27
TERMUX_PKG_SHA256=6eaf75ce1e73be63894fb04d1fd0bfa9f54f33e88269743dd8f2ff54e27ea043
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/cyrus-sasl-$TERMUX_PKG_VERSION.tar.xz
# Seems to be race issues in build (symlink creation)::
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
lt_cv_deplibs_check_method=pass_all
ac_cv_func_syslog=no
ac_cv_header_syslog_h=no
--disable-gssapi
--disable-otp
--sysconfdir=$TERMUX_PREFIX/etc
--with-dblib=none
--with-dbpath=$TERMUX_PREFIX/var/lib/sasldb
--without-des
--without-saslauthd
--with-plugindir=$TERMUX_PREFIX/lib/sasl2
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pluginviewer"

termux_step_post_configure() {
	# Build wants to run makemd5 at build time:
	gcc $TERMUX_PKG_SRCDIR/include/makemd5.c -o $TERMUX_PKG_BUILDDIR/include/makemd5
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/include/makemd5
}

termux_step_post_massage() {
	for sub in anonymous crammd5 digestmd5 plain; do
		local base=lib/sasl2/lib${sub}
		if [ ! -f ${base}.so ]; then
			termux_error_exit "libsasl not packaged with $base"
		fi
	done
}
