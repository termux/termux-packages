TERMUX_PKG_HOMEPAGE=http://www.net-snmp.org/
TERMUX_PKG_DESCRIPTION="Various tools relating to the Simple Network Management Protocol"
# Licenses: HPND, BSD 3-Clause, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.9.1
TERMUX_PKG_SRCURL=https://github.com/net-snmp/net-snmp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bdff5fe0915369971e4c7f8e43283fa5fdd08785c7d3b61431465562112d86e7
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
