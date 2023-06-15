TERMUX_PKG_HOMEPAGE="https://www.cups.org/"
TERMUX_PKG_DESCRIPTION="Common UNIX Printing System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.5
TERMUX_PKG_SRCURL=https://github.com/OpenPrinting/cups/releases/download/v${TERMUX_PKG_VERSION}/cups-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=9a404de55f74525b0a6851df0cfdebfa1215aec0e7c2f7be6b9b09b6916fb000
TERMUX_PKG_DEPENDS="libc++, libcrypt, libgnutls, libiconv, zlib"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-tls=gnutls
"
TERMUX_PKG_CONFFILES="
etc/cups/cups-files.conf
etc/cups/cupsd.conf
etc/cups/snmp.conf
"

TERMUX_PKG_SERVICE_SCRIPT=("cupsd" "mkdir -p $TERMUX_PREFIX/var/run/cups && exec cupsd -f")

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run/cups
	EOF
}
