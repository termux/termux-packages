TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/inetutils/
TERMUX_PKG_DESCRIPTION="Collection of common network programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/inetutils/inetutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d547f69172df73afef691a0f7886280fd781acea28def4ff4b4b212086a89d80
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
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
	CPPFLAGS+=" -DNO_INLINE_GETPASS=1 -DLOGIN_PROCESS=6 -DDEAD_PROCESS=8 -DLOG_NFACILITIES=24 -fcommon"
	touch -d "next hour" ./man/whois.1
}

termux_step_post_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/malloc.h $TERMUX_PKG_BUILDDIR/lib/
}
