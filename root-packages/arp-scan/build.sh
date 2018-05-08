TERMUX_PKG_HOMEPAGE=https://github.com/royhills/arp-scan
TERMUX_PKG_DESCRIPTION="arp-scan is a command-line tool for system discovery and fingerprinting. It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received."
TERMUX_PKG_VERSION=1.9
TERMUX_PKG_SHA256=b2a446a170e4a2feeb825cd08db48a147f8dffae702077f33e456c4200e7afb0
TERMUX_PKG_SRCURL=https://github.com/royhills/arp-scan/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libpcap"
TERMUX_PKG_BUILD_DEPENDS="libpcap-dev"

if [ $TERMUX_ARCH_BITS == 32 ]; then
    # Retrieved from compilation on device:
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="pgac_cv_snprintf_long_long_int_format=%lld"
fi

termux_step_pre_configure () {
	aclocal
    	autoheader
	automake --add-missing
	autoconf
}
