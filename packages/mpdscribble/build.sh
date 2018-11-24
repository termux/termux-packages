TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpdscribble/
TERMUX_PKG_DESCRIPTION="A Music Player Daemon (MPD) client which submits information about tracks being played to a scrobbler"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=0.22
TERMUX_PKG_SHA256=9f6d73e1d0d44bf782c199732acc91bb07efc1c02ae04d037d711860dd8e4012
TERMUX_PKG_SRCURL=https://github.com/MusicPlayerDaemon/mpdscribble/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, mpd, libmpdclient, glib"
TERMUX_PKG_CONFFILES="$TERMUX_PREFIX/etc/mpdscribble.conf"

termux_step_pre_configure () {
	NOCONFIGURE=1 ./autogen.sh
	export LDFLAGS=" -llog"
}

termux_step_post_make_install () {
	install $TERMUX_PKG_SRCDIR/doc/mpdscribble.conf $TERMUX_PREFIX/etc/
}
termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p ~/.mpdscribble" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
