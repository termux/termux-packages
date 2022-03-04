TERMUX_PKG_HOMEPAGE=https://transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.00
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/transmission/transmission.git
TERMUX_PKG_DEPENDS="libcurl, libevent, miniupnpc, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk --enable-lightweight --cache-file=termux_configure.cache"
# transmission already puts timestamps in the info printed to stdout so no need for svlogd -tt,
# therefore we override the transmission/log run script
TERMUX_PKG_SERVICE_SCRIPT=(
	"transmission" 'exec transmission-daemon -f 2>&1'
	"transmission/log" 'mkdir -p "$LOGDIR/sv/transmission"\nexec svlogd "$LOGDIR/sv/transmission"'
)

termux_step_pre_configure() {
	CFLAGS+=" -D_POSIX_C_SOURCE=200809L"
	./autogen.sh

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
