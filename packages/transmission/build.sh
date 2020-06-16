TERMUX_PKG_HOMEPAGE=https://transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=3.00
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/transmission/transmission.git
# lint-packages complains if SHA256 is not set
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="libcurl, libevent, miniupnpc, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk --enable-lightweight --cache-file=termux_configure.cache"
# transmission already puts timestamps in the info printed to stdout so no need for svlogd -tt,
# therefore we override the transmission/log run script
TERMUX_PKG_SERVICE_SCRIPT=(
	"transmission" 'mkdir -p ~/torrent/torrent-files\nmkdir -p ~/torrent/download\nexec transmission-daemon -f -c ~/torrent/torrent-files -w ~/torrent/download 2>&1'
	"transmission/log" 'mkdir -p "$LOGDIR/sv/transmission"\nexec svlogd "$LOGDIR/sv/transmission"'
)

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone --depth 1 \
			--branch $TERMUX_PKG_VERSION \
			$TERMUX_PKG_SRCURL \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init --recursive
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	rm -rf $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure() {
	CFLAGS+=" -D_POSIX_C_SOURCE=200809L"
	./autogen.sh

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
