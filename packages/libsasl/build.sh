TERMUX_PKG_HOMEPAGE=https://www.cyrusimap.org/sasl/
TERMUX_PKG_DESCRIPTION="Cyrus SASL - authentication abstraction library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.28
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/cyrus-sasl-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=67f1945057d679414533a30fe860aeb2714f5167a8c03041e023a65f629a9351
TERMUX_PKG_BREAKS="libsasl-dev"
TERMUX_PKG_REPLACES="libsasl-dev"
# Seems to be race issues in build (symlink creation)::
TERMUX_PKG_MAKE_PROCESSES=1
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
--enable-login
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/pluginviewer"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_massage() {
	for sub in anonymous crammd5 digestmd5 plain login; do
		local base=lib/sasl2/lib${sub}
		if [ ! -f ${base}.so ]; then
			termux_error_exit "libsasl not packaged with $base"
		fi
	done
}
