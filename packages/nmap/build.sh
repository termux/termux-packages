TERMUX_PKG_HOMEPAGE=https://nmap.org/
TERMUX_PKG_DESCRIPTION="Utility for network discovery and security auditing"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.97"
TERMUX_PKG_SRCURL=https://nmap.org/dist/nmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=af98f27925c670c257dd96a9ddf2724e06cb79b2fd1e0d08c9206316be1645c0
TERMUX_PKG_DEPENDS="libc++, liblua54, libpcap, libssh2, openssl, pcre2, resolv-conf, zlib"
TERMUX_PKG_RECOMMENDS="nmap-ncat"
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
