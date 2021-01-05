TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org/
TERMUX_PKG_DESCRIPTION="WiFi security auditing tools suite"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.6-git
_COMMIT=e998873f148898179d3e1679bc09a087ae42fb74
TERMUX_PKG_SRCURL=https://github.com/aircrack-ng/aircrack-ng/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=35acbdf655ff6f73aa614c409bf385005b920fab2ef64f2102c546fa9e935da5
TERMUX_PKG_DEPENDS="libc++, libnl, openssl, libpcap, pciutils, ethtool"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
