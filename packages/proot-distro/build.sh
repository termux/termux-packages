TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.10
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=305b106b2a580c08e3cf8ef6f4196071933f9d20d299944330f17c9bd84a0ab9
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot, tar, xz-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Allow to edit distribution plug-ins.
TERMUX_PKG_CONFFILES="
etc/proot-distro/alpine.sh
etc/proot-distro/archlinux.sh
etc/proot-distro/nethunter.sh
etc/proot-distro/ubuntu-18.04.sh
etc/proot-distro/ubuntu-20.04.sh
"

termux_step_make_install() {
	./install.sh
}

termux_step_create_debscripts() {
	# Don't break older installations.
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ -f "$TERMUX_PREFIX/etc/proot-distro/ubuntu.sh" ]; then
		cp -f "$TERMUX_PREFIX/etc/proot-distro/ubuntu.sh" "$TERMUX_PREFIX/etc/proot-distro/ubuntu-20.04.sh"
	else
		cp -f "$TERMUX_PREFIX/etc/proot-distro/ubuntu-20.04.sh" "$TERMUX_PREFIX/etc/proot-distro/ubuntu.sh"
	fi
	exit 0
	POSTINST_EOF

	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "remove" ]; then
		exit 0
	fi
	rm -f $TERMUX_PREFIX/etc/proot-distro/ubuntu.sh
	exit 0
	PRERM_EOF

	chmod 0755 postinst prerm
}
