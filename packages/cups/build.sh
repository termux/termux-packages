TERMUX_PKG_HOMEPAGE="https://www.cups.org/"
TERMUX_PKG_DESCRIPTION="Common UNIX Printing System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.11"
TERMUX_PKG_SRCURL=https://github.com/OpenPrinting/cups/releases/download/v${TERMUX_PKG_VERSION}/cups-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=9a88fe1da3a29a917c3fc67ce6eb3178399d68e1a548c6d86c70d9b13651fd71
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


termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run/cups
	EOF
}
