TERMUX_PKG_HOMEPAGE=http://blog.calhariz.com/index.php/tag/at
TERMUX_PKG_DESCRIPTION="AT and batch delayed command scheduling utility and daemon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://software.calhariz.com/at/at_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=aabe6e5cb6dd19fe9fb25c2747492f2db38762b95ea41b86f949609c39fb55c4
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
