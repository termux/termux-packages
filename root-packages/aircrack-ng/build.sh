TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org
TERMUX_PKG_DESCRIPTION="an 802.11 WEP and WPA-PSK keys cracking program"
TERMUX_PKG_VERSION=1.2-rc4
TERMUX_PKG_SRCURL=https://download.aircrack-ng.org/aircrack-ng-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d93ac16aade5b4d37ab8cdf6ce4b855835096ccf83deb65ffdeff6d666eaff36
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="libnl, libnl-dev, openssl, openssl-dev, libpcap, libpcap-dev"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64"
# See https://github.com/termux/termux-root-packages/issues/11
