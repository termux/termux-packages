TERMUX_PKG_HOMEPAGE="https://www.cups.org/"
TERMUX_PKG_DESCRIPTION="Common UNIX Printing System"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_SRCURL="https://github.com/apple/cups/releases/download/v${TERMUX_PKG_VERSION}/cups-${TERMUX_PKG_VERSION}-source.tar.gz"
TERMUX_PKG_SHA256="261fd948bce8647b6d5cb2a1784f0c24cc52b5c4e827b71d726020bcc502f3ee"
TERMUX_PKG_DEPENDS="libiconv, libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/cups/cups-files.conf, etc/cups/cupsd.conf, etc/cups/snmp.conf"

termux_step_make() {
	cd "$TERMUX_PKG_BUILDDIR"
	make LIBS="-pthread -lm -lcrypt -liconv -lz -L$TERMUX_PREFIX/lib -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags -Wl,--as-needed -Wl,-z,relro,-z,now" -j${TERMUX_MAKE_PROCESSES}
}

