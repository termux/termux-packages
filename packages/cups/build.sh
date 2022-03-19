TERMUX_PKG_HOMEPAGE="https://www.cups.org/"
TERMUX_PKG_DESCRIPTION="Common UNIX Printing System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL="https://github.com/apple/cups/releases/download/v${TERMUX_PKG_VERSION}/cups-${TERMUX_PKG_VERSION}-source.tar.gz"
TERMUX_PKG_SHA256="261fd948bce8647b6d5cb2a1784f0c24cc52b5c4e827b71d726020bcc502f3ee"
TERMUX_PKG_DEPENDS="libc++, libiconv, libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="
etc/cups/cups-files.conf
etc/cups/cupsd.conf
etc/cups/snmp.conf
"

TERMUX_PKG_SERVICE_SCRIPT=("cupsd" "mkdir -p $TERMUX_PREFIX/var/run/cups && exec cupsd -f")

termux_step_make() {
	make LIBS="-pthread $LDFLAGS -Wl,--hash-style=both -lm -lcrypt -liconv -lz" -j${TERMUX_MAKE_PROCESSES}
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p $TERMUX_PREFIX/var/run/cups
	EOF
}
