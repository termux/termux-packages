TERMUX_PKG_HOMEPAGE=https://nmap.org/
TERMUX_PKG_DESCRIPTION="Utility for network discovery and security auditing"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=7.80
TERMUX_PKG_SRCURL=https://nmap.org/dist/nmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa
# Depend on netcat so that it gets installed automatically when installing
# nmap, since the ncat program is usually distributed as part of nmap.
TERMUX_PKG_DEPENDS="libc++, libpcap, pcre, openssl, resolv-conf, netcat, liblua, libssh2, zlib"
# --without-nmap-update to avoid linking against libsvn_client:
# --without-zenmap to avoid python scripts for graphical gtk frontend:
# --without-ndiff to avoid python2-using ndiff utility:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-static --with-liblua=$TERMUX_PREFIX --without-nmap-update --without-zenmap --without-ndiff"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	# Setup 'netcat' and 'nc' as symlink to 'ncat', since the other netcat implementations
	# are outdated (gnu-netcat) or non-portable (openbsd-netcat).
	for prog in netcat nc; do
		cd $TERMUX_PREFIX/bin
		ln -s -f ncat $prog
		cd $TERMUX_PREFIX/share/man/man1
		ln -s -f ncat.1 ${prog}.1
	done
}
