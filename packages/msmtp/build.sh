TERMUX_PKG_HOMEPAGE=http://msmtp.sourceforge.net
TERMUX_PKG_DESCRIPTION="light SMTP client"
TERMUX_PKG_VERSION=1.6.6
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/msmtp/files/msmtp/1.6.6/msmtp-1.6.6.tar.xz
TERMUX_PKG_SHA256=da15db1f62bd0201fce5310adb89c86188be91cd745b7cb3b62b81a501e7fb5e
#TERMUX_PKG_BUILD_IN_SRC=yes
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
#TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="libgnutls, libidn"
termux_step_pre_configure () {
	LDFLAGS=" -llog"
	cp $TERMUX_SCRIPTDIR/packages/alpine/getpass* src/
	autoreconf -if
}
