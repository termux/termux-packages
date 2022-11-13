TERMUX_PKG_HOMEPAGE="https://www.cups.org/"
TERMUX_PKG_DESCRIPTION="Common UNIX Printing System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.6
TERMUX_PKG_SRCURL=https://github.com/apple/cups/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a96912fc88f62c5d8ac9b251bf0652f1cbe7e69cde16919103aea39f31a1a84
TERMUX_PKG_DEPENDS="gnutls, libc++, libcrypt, libiconv, zlib"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true

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
