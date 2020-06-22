TERMUX_PKG_HOMEPAGE=https://github.com/neutrinolabs/xrdp
TERMUX_PKG_DESCRIPTION="An open source remote desktop protocol (RDP) server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.9.13
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://github.com/neutrinolabs/xrdp/releases/download/v${TERMUX_PKG_VERSION}/xrdp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=59fe6f32f17e7b86c132e069ee96b754f0555b1197e44e4d070e85591d0271ff
TERMUX_PKG_DEPENDS="libandroid-shmem, libcrypt, libice, libsm, libuuid, libx11, libxau, libxcb, libxfixes, libxdmcp, libxrandr, openssl, procps, tigervnc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pam
--enable-static
--with-socketdir=$TERMUX_PREFIX/tmp/.xrdp
"

TERMUX_PKG_CONFFILES="
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
etc/xrdp/km-0000080c.ini
etc/xrdp/km-00000813.ini
etc/xrdp/km-00000816.ini
etc/xrdp/km-0000100c.ini
etc/xrdp/km-00010409.ini
etc/xrdp/reconnectwm.sh
etc/xrdp/sesman.ini
etc/xrdp/startwm.sh
etc/xrdp/xrdp.ini
etc/xrdp/xrdp.sh
etc/xrdp/xrdp_keyboard.ini
"

TERMUX_PKG_RM_AFTER_INSTALL="
etc/default
etc/init.d
"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem -llog"
}

termux_step_post_make_install() {
	mv -f "${TERMUX_PREFIX}/sbin/xrdp" "${TERMUX_PREFIX}/bin/xrdp"
	mv -f "${TERMUX_PREFIX}/sbin/xrdp-chansrv" "${TERMUX_PREFIX}/bin/xrdp-chansrv"
	mv -f "${TERMUX_PREFIX}/sbin/xrdp-sesman" "${TERMUX_PREFIX}/bin/xrdp-sesman"
	mkdir -p "${TERMUX_PREFIX}/libexec/xrdp"

	for bin in xrdp xrdp-chansrv xrdp-genkeymap xrdp-keygen xrdp-sesadmin xrdp-sesman xrdp-sesrun; do
		mv -f "${TERMUX_PREFIX}/bin/${bin}" "${TERMUX_PREFIX}/libexec/xrdp/${bin}"
		{
			echo "#!${TERMUX_PREFIX}/bin/sh"
			echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${TERMUX_PREFIX}/lib/xrdp"
			echo "exec ${TERMUX_PREFIX}/libexec/xrdp/${bin} \"\${@}\""
		} > "${TERMUX_PREFIX}/bin/${bin}"
		chmod 700 "${TERMUX_PREFIX}/bin/${bin}"
	done
	unset bin
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
