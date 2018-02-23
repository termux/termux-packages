TERMUX_PKG_HOMEPAGE=http://www.hping.org
TERMUX_PKG_DESCRIPTION="hping is a command-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap"
TERMUX_PKG_SHA256=f5a671a62a11dc8114fa98eade19542ed1c3aa3c832b0e572ca0eb1a5a4faee8
TERMUX_PKG_SRCURL=http://www.hping.org/hping3-20051105.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
termux_step_post_make_install() {
 mkdir -p "$TERMUX_PREFIX/share/man/man8"
	cp "$TERMUX_PKG_SRCDIR/docs/hping3.8" "$TERMUX_PREFIX/share/man/man8/"
}
