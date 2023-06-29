TERMUX_PKG_HOMEPAGE=https://github.com/pystardust/ani-cli
TERMUX_PKG_DESCRIPTION="A cli to browse and watch anime"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.4
TERMUX_PKG_SRCURL=https://github.com/pystardust/ani-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41d400dba237763efd44b682b420817bb158fa114851b72ac9e9bd74256c1da4
TERMUX_PKG_DEPENDS="aria2, ffmpeg, fzf, grep, sed, wget"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ani-cli

	local mpv_android=$TERMUX_PREFIX/opt/ani-cli/bin/mpv
	mkdir -p $(dirname $mpv_android)
	rm -rf $mpv_android
	sed 's|@TERMUX_PREFIX@|'"$TERMUX_PREFIX"'|g' \
		$TERMUX_PKG_BUILDER_DIR/mpv.in > $mpv_android
	chmod 0700 $mpv_android
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo
		echo Note that you need to have the mpv android app installed.
		echo
	EOF
}
