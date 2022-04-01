TERMUX_PKG_HOMEPAGE=https://github.com/cronie-crond/cronie/
TERMUX_PKG_DESCRIPTION="Daemon that runs specified programs at scheduled times and related tools"
TERMUX_PKG_LICENSE="ISC, BSD 2-Clause, BSD 3-Clause, GPL-2.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.obstack"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/cronie-crond/cronie/releases/download/cronie-${TERMUX_PKG_VERSION}/cronie-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f7cc263d21838b53a9943eb2a26b862059e2ae36c3f11789ac33cd6818e3628
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

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run
	mkdir -p $TERMUX_PREFIX/var/spool/cron
	mkdir -p $TERMUX_PREFIX/etc/cron.d
	EOF
}
