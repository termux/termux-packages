TERMUX_PKG_HOMEPAGE=http://www.snmptt.org/
TERMUX_PKG_DESCRIPTION="SNMP trap translator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/snmptt/snmptt_${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=91fb6146a08c0d143e4193f1fffdb697f769f75666d72a73eeb78c013b8a227f
TERMUX_PKG_DEPENDS="net-snmp, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	find . -maxdepth 1 -type f -name 'snmptt*' | xargs -n 1 sed -i \
		-e 's:\([^A-Za-z0-9.]\)/etc/:\1'$TERMUX_PREFIX'/etc/:g' \
		-e 's:\([^A-Za-z0-9.]\)/sbin/:\1'$TERMUX_PREFIX'/bin/:g' \
		-e 's:\([^A-Za-z0-9.]\)/usr/sbin/:\1'$TERMUX_PREFIX'/bin/:g' \
		-e 's:\([^A-Za-z0-9.]\)/var/:\1'$TERMUX_PREFIX'/var/:g' \
		-e 's:\([^A-Za-z0-9.]\)/usr/local/etc/:\1'$TERMUX_PREFIX'/local/etc/:g'
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin \
		snmptt snmptt-net-snmp-test \
		snmpttconvert snmpttconvertmib \
		snmptthandler snmptthandler-embedded
	install -Dm600 -t $TERMUX_PREFIX/share/snmptt/examples examples/*
	install -Dm600 -t $TERMUX_PREFIX/etc/snmptt snmptt.ini
	install -Dm600 -T examples/snmptt.conf.generic \
		$TERMUX_PREFIX/etc/snmptt/snmptt.conf
}
