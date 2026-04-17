TERMUX_PKG_HOMEPAGE="https://www.cups.org/"
TERMUX_PKG_DESCRIPTION="Common UNIX Printing System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.17"
TERMUX_PKG_SRCURL=https://github.com/OpenPrinting/cups/releases/download/v${TERMUX_PKG_VERSION}/cups-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=89c703238de210d4f4f4e5d4269e3d60c4b2f487aad75a8a1eaecd659e4d0b77
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcrypt, libgnutls, libiconv, zlib"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-tls=gnutls
"
TERMUX_PKG_EXTRA_MAKE_ARGS="
DBUSDIR=$PREFIX/etc/dbus-1
"
TERMUX_PKG_CONFFILES="
etc/cups/cups-files.conf
etc/cups/cupsd.conf
etc/cups/snmp.conf
"

TERMUX_PKG_SERVICE_SCRIPT=("cupsd" "mkdir -p $TERMUX_PREFIX/var/run/cups && exec cupsd -f")

termux_step_pre_configure() {
	export CHOWNPROG=true CHGRPPROG=true
}

termux_step_post_massage() {
	# Restore world-readable permissions stripped by termux_step_massage
	chmod -R o+rX share/doc/cups
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run/cups
	mkdir -p $TERMUX_PREFIX/var/spool/cups/tmp
	mkdir -p $TERMUX_PREFIX/var/cache/cups
	EOF
}
