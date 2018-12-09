TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org/
TERMUX_PKG_DESCRIPTION="WiFi security auditing tools suite"
TERMUX_PKG_VERSION=1.2-rc4 #1.5.1 (requires autoconf, automake, libtool, shtool, pkg-config (and maybe libstdc and make/gmake) support)
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/aircrack-ng/aircrack-ng/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ed241ea423cab1c86e7882e901d5200d91b2f97d7efd703b0acf17742be47f9b
TERMUX_PKG_DEPENDS="libnl, openssl, libpcap, pciutils"
TERMUX_PKG_BUILD_DEPENDS="libnl-dev, openssl-dev, libpcap-dev"
TERMUX_PKG_BUILD_IN_SRC=yes

# TODO: in termux-packages, add support for these packages: shtool, libstdc, gmake