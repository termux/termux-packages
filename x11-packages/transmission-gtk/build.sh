TERMUX_PKG_HOMEPAGE=https://transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client (gtk3)"
# with OpenSSL linking exception:
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, licenses/gpl-2.0.txt, licenses/gpl-3.0.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_SRCURL=git+https://github.com/transmission/transmission
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="glib, gtk3, gtkmm3, libatkmm-1.6, libc++, libcairomm-1.0, libcurl, libevent, libglibmm-2.4, libpangomm-1.4, libpsl, libsigc++-2.0, miniupnpc, natpmpc, openssl"
TERMUX_PKG_CONFLICTS="transmission"
TERMUX_PKG_REPLACES="transmission"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GTK=ON
-DENABLE_QT=OFF
-DENABLE_TESTS=OFF
-DENABLE_NLS=ON
-DRUN_CLANG_TIDY=OFF
-DUSE_GTK_VERSION=3
-DGLIB_COMPILE_RESOURCES_EXECUTABLE=glib-compile-resources
"
# transmission already puts timestamps in the info printed to stdout so no need for svlogd -tt,
# therefore we override the transmission/log run script
TERMUX_PKG_SERVICE_SCRIPT=(
	"transmission" 'exec transmission-daemon -f 2>&1'
	"transmission/log" 'mkdir -p "$LOGDIR/sv/transmission"\nexec svlogd "$LOGDIR/sv/transmission"'
)

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
