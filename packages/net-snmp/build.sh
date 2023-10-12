TERMUX_PKG_HOMEPAGE=http://www.net-snmp.org/
TERMUX_PKG_DESCRIPTION="Various tools relating to the Simple Network Management Protocol"
# Licenses: HPND, BSD 3-Clause, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.9.3
TERMUX_PKG_SRCURL=https://github.com/net-snmp/net-snmp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=022c7e67c338a6829637dbb73b6a3ee602d1d3dd737249ce8d4f18ab8e640609
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-agentx-socket=$TERMUX_PREFIX/var/agentx/master
--with-default-snmp-version=3
--with-logfile=$TERMUX_PREFIX/var/log/net-snmpd.log
--with-mnttab=$TERMUX_PREFIX/etc/mtab
--with-persistent-directory=$TERMUX_PREFIX/var/lib/net-snmp
--with-sys-contact=root@localhost
--with-sys-location=Unknown
--with-temp-file-pattern=$TERMUX_PREFIX/tmp/snmpdXXXXXX
ac_cv_path_LPSTAT_PATH=$TERMUX_PREFIX/bin/lpstat
"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "x86_64" ]; then
		CPPFLAGS+=" -DOPENSSL_NO_INLINE_ASM"
	fi
}
