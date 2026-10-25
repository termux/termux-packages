TERMUX_PKG_HOMEPAGE=https://nmap.org/
TERMUX_PKG_DESCRIPTION="Utility for network discovery and security auditing"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.992"
TERMUX_PKG_SRCURL="https://nmap.org/dist/nmap-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=0c12660eddbf7eabeff6996cb0c044a4eadf2bb0c6fbcb340d6cf72b1caee402
TERMUX_PKG_DEPENDS="libc++, lua54, libpcap, libssh2, openssl, pcre2, resolv-conf, zlib"
TERMUX_PKG_BREAKS="nmap-ncat"
TERMUX_PKG_REPLACES="nmap-ncat"
TERMUX_PKG_PROVIDES="nc, ncat, netcat"
# --without-nmap-update to avoid linking against libsvn_client:
# --without-zenmap to avoid python scripts for graphical gtk frontend:
# --without-ndiff to avoid python2-using ndiff utility:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-static
--with-liblua=$TERMUX_PREFIX
--without-nmap-update
--without-zenmap
--without-ndiff
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		STRIP="$(command -v true)"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_STRIP=$STRIP"
}

termux_step_post_massage() {
	mv -v bin/ncat bin/netcat-nmap
	mv -v share/man/man1/ncat.1.gz share/man/man1/netcat-nmap.1.gz
}
