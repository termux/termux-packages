TERMUX_PKG_HOMEPAGE=https://github.com/cronie-crond/cronie/
TERMUX_PKG_DESCRIPTION="Daemon that runs specified programs at scheduled times and related tools"
TERMUX_PKG_LICENSE="ISC, BSD 2-Clause, BSD 3-Clause, GPL-2.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.obstack"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.1"
TERMUX_PKG_SRCURL=https://github.com/cronie-crond/cronie/releases/download/cronie-${TERMUX_PKG_VERSION}/cronie-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=78033100c24413f0c40f93e6138774d6a4f55bc31050567b90db45a2f9f1b954
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="dash"
TERMUX_PKG_RECOMMENDS="nano"
TERMUX_PKG_SUGGESTS="termux-services"
TERMUX_PKG_CONFLICTS="busybox (<< 1.31.1-11)"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-anacron
--disable-pam
--with-editor=$TERMUX_PREFIX/bin/nano
"

TERMUX_PKG_SERVICE_SCRIPT=("crond" 'exec crond -n -s')

termux_step_post_get_source() {
    sed -i "s|\"/usr/sbin/sendmail\"|\"${TERMUX_PREFIX}/bin/sendmail\"|" ${TERMUX_PKG_SRCDIR}/configure
    sed -i "s|\"/usr/sbin/sendmail\"|\"${TERMUX_PREFIX}/bin/sendmail\"|" ${TERMUX_PKG_SRCDIR}/src/cron.c
    sed -i "s|\"/tmp\"|\"${TERMUX_PREFIX}/tmp\"|" ${TERMUX_PKG_SRCDIR}/src/crontab.c
    sed -i "s|_PATH_BSHELL \"/bin/sh\"|_PATH_BSHELL \"${TERMUX_PREFIX}/bin/sh\"|" ${TERMUX_PKG_SRCDIR}/src/crontab.c
    sed -i "s|_PATH_STDPATH \"/usr/bin:/bin:/usr/sbin:/sbin\"|_PATH_STDPATH \"${TERMUX_PREFIX}/bin\"|" ${TERMUX_PKG_SRCDIR}/src/crontab.c
    sed -i "s|_PATH_TMP \"/tmp\"|_PATH_TMP \"${TERMUX_PREFIX}/tmp\"|" ${TERMUX_PKG_SRCDIR}/src/crontab.c
    sed -i "s|getdtablesize()|sysconf(_SC_OPEN_MAX)|" ${TERMUX_PKG_SRCDIR}/src/do_command.c
    sed -i "s|getdtablesize()|sysconf(_SC_OPEN_MAX)|" ${TERMUX_PKG_SRCDIR}/src/popen.c
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run
	mkdir -p $TERMUX_PREFIX/var/spool/cron
	mkdir -p $TERMUX_PREFIX/etc/cron.d
	EOF
}
