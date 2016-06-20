TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/inetutils/
TERMUX_PKG_DESCRIPTION="Collection of common network programs"
TERMUX_PKG_VERSION=1.9.4
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/inetutils/inetutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="readline, libutil"
# These are old cruft / not suited for android:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ifconfig --disable-rcp --disable-rlogin --disable-rsh --disable-rexecd --disable-uucpd --disable-rexec --disable-ping --disable-ping6 --disable-hostname"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"

CPPFLAGS+=" -DLOGIN_PROCESS=6 -DDEAD_PROCESS=8 -DLOG_NFACILITIES=24"
LDFLAGS+=" -llog" # for syslog
