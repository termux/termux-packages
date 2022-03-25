TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/inetutils/
TERMUX_PKG_DESCRIPTION="Collection of common network programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.4
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/inetutils/inetutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_SUGGESTS="whois"
TERMUX_PKG_RM_AFTER_INSTALL="bin/whois share/man/man1/whois.1"
# These are old cruft / not suited for android
# (we --disable-traceroute as it requires root
# in favour of tracepath, which sets up traceroute
# as a symlink to tracepath):
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ifconfig
--disable-ping
--disable-ping6
--disable-rcp
--disable-rexec
--disable-rexecd
--disable-rlogin
--disable-rsh
--disable-traceroute
--disable-uucpd
ac_cv_lib_crypt_crypt=no
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DLOGIN_PROCESS=6 -DDEAD_PROCESS=8 -DLOG_NFACILITIES=24 -fcommon"
	touch -d "next hour" ./man/whois.1
}
