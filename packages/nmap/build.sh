TERMUX_PKG_HOMEPAGE=https://nmap.org/
TERMUX_PKG_DESCRIPTION="Utility for network discovery and security auditing"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.97"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://nmap.org/dist/nmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=af98f27925c670c257dd96a9ddf2724e06cb79b2fd1e0d08c9206316be1645c0
TERMUX_PKG_DEPENDS="libc++, liblua54, libpcap, libssh2, openssl, pcre2, resolv-conf, zlib"
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

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			# 'netcat-nmap' can be a 'nc' alternative
			update-alternatives \
			--install "$TERMUX_PREFIX/bin/nc" nc "$TERMUX_PREFIX/bin/netcat-nmap" 40 \
			--slave "$TERMUX_PREFIX/bin/ncat" ncat "$TERMUX_PREFIX/bin/netcat-nmap" \
			--slave "$TERMUX_PREFIX/bin/netcat" netcat "$TERMUX_PREFIX/bin/netcat-nmap" \
			--slave "$TERMUX_PREFIX/share/man/man1/nc.1.gz" nc.1.gz "$TERMUX_PREFIX/share/man/man1/netcat-nmap.1.gz" \
			--slave "$TERMUX_PREFIX/share/man/man1/ncat.1.gz" ncat.1.gz "$TERMUX_PREFIX/share/man/man1/netcat-nmap.1.gz" \
			--slave "$TERMUX_PREFIX/share/man/man1/netcat.1.gz" netcat.1.gz "$TERMUX_PREFIX/share/man/man1/netcat-nmap.1.gz"
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove nc "$TERMUX_PREFIX/bin/ncat"
		fi
	fi
	EOF
}
