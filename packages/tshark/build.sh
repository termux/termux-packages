TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org
TERMUX_PKG_DESCRIPTION="network protocol analyzer and sniffer"
TERMUX_PKG_VERSION=2.4.2
TERMUX_PKG_SRCURL=https://github.com/wireshark/wireshark/archive/wireshark-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9b60b3a23e2f24f0f9a75d67364b8eef649960c9d1926697739825a3a7a9861
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="libnl, libnl-dev, openssl,openssl-dev " 
# As GUI is not supported by termux we need to disable wireshark 
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$PREFIX --with-qt=no --disable-wireshark" 
TERMUX_PKG_BUILD_IN_SRC=yes
