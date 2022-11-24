TERMUX_PKG_HOMEPAGE=https://github.com/royhills/arp-scan
TERMUX_PKG_DESCRIPTION="arp-scan is a command-line tool for system discovery and fingerprinting. It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.8
TERMUX_PKG_SRCURL=https://github.com/royhills/arp-scan/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9b75ceaef6348f5951b06c773ec7a243a9e780e160eafebc369f9c27f6a7d3f
TERMUX_PKG_DEPENDS="libpcap"

if [[ ${TERMUX_ARCH_BITS} == 32 ]]; then
	# Retrieved from compilation on device:
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="pgac_cv_snprintf_long_long_int_format=%lld"
fi

termux_step_pre_configure () {
	cp ${TERMUX_PKG_BUILDER_DIR}/hsearch/* ${TERMUX_PKG_SRCDIR}/
	aclocal
	autoheader
	automake --add-missing
	autoconf
}
