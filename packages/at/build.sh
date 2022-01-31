TERMUX_PKG_HOMEPAGE=http://blog.calhariz.com/index.php/tag/at
TERMUX_PKG_DESCRIPTION="AT and batch delayed command scheduling utility and daemon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/at/-/archive/upstream/${TERMUX_PKG_VERSION}/at-upstream-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8239236f692aba2dba1c5c2cd97ae6aa02bbfe14e23a7e292131b0594a735d84
TERMUX_PKG_SUGGESTS="termux-services"
TERMUX_PKG_BUILD_IN_SRC=true

# Force make -j1.
TERMUX_MAKE_PROCESSES=1

# Setting loadavg_mx to 8.0 as most devices (8 core)
# do not have loadavg below 5-6.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_SENDMAIL=$TERMUX_PREFIX/bin/sendmail
--with-loadavg_mx=8.0
--with-etcdir=$TERMUX_PREFIX/etc
--with-jobdir=$TERMUX_PREFIX/var/spool/atd
--with-atspool=$TERMUX_PREFIX/var/spool/atd
"

# at.allow and at.deny are not supported in Termux.
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5
"

TERMUX_PKG_SERVICE_SCRIPT=("atd" "mkdir -p $TERMUX_PREFIX/var/run && exec atd")

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run
	EOF
}
