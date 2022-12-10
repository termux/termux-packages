TERMUX_PKG_HOMEPAGE=https://github.com/neutrinolabs/xrdp
TERMUX_PKG_DESCRIPTION="An open source remote desktop protocol (RDP) server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.21
TERMUX_PKG_SRCURL=https://github.com/neutrinolabs/xrdp/releases/download/v${TERMUX_PKG_VERSION}/xrdp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aae7f1a725bf92a327276de4f77469a5540456c934bbe8a44da67d4974193fb8
TERMUX_PKG_DEPENDS="libandroid-shmem, libx11, libxfixes, libxrandr, openssl, procps, tigervnc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pam
--enable-static
--enable-strict-locations
--with-socketdir=$TERMUX_PREFIX/tmp/.xrdp
"

TERMUX_PKG_CONFFILES="
etc/xrdp/cert.pem
etc/xrdp/key.pem
etc/xrdp/km-00000406.ini
etc/xrdp/km-00000407.ini
etc/xrdp/km-00000409.ini
etc/xrdp/km-0000040a.ini
etc/xrdp/km-0000040b.ini
etc/xrdp/km-0000040c.ini
etc/xrdp/km-00000410.ini
etc/xrdp/km-00000411.ini
etc/xrdp/km-00000412.ini
etc/xrdp/km-00000414.ini
etc/xrdp/km-00000415.ini
etc/xrdp/km-00000416.ini
etc/xrdp/km-00000419.ini
etc/xrdp/km-0000041d.ini
etc/xrdp/km-00000807.ini
etc/xrdp/km-00000809.ini
etc/xrdp/km-0000080a.ini
etc/xrdp/km-0000080c.ini
etc/xrdp/km-00000813.ini
etc/xrdp/km-00000816.ini
etc/xrdp/km-0000100c.ini
etc/xrdp/km-00010409.ini
etc/xrdp/km-19360409.ini
etc/xrdp/pulse/default.pa
etc/xrdp/reconnectwm.sh
etc/xrdp/sesman.ini
etc/xrdp/startwm.sh
etc/xrdp/xrdp.ini
etc/xrdp/xrdp_keyboard.ini
"

TERMUX_PKG_RM_AFTER_INSTALL="
etc/default
etc/init.d
etc/xrdp/cert.pem
etc/xrdp/key.pem
"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,-rpath=${TERMUX_PREFIX}/lib/xrdp -Wl,--enable-new-dtags"
	export LIBS="-landroid-shmem"
}

termux_step_create_debscripts() {
	{
		echo "#!${TERMUX_PREFIX}/bin/sh"
		echo "if [ ! -e \"${TERMUX_PREFIX}/etc/xrdp/rsakeys.ini\" ]; then"
		echo "    xrdp-keygen xrdp \"${TERMUX_PREFIX}/etc/xrdp/rsakeys.ini\""
		echo "fi"
	} > ./postinst
	chmod 755 postinst
}
