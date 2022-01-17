TERMUX_PKG_HOMEPAGE=https://github.com/azatoth/minidlna
TERMUX_PKG_DESCRIPTION="A server software with the aim of being fully compliant with DLNA/UPnP-AV clients"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/m/minidlna/minidlna_${TERMUX_PKG_VERSION}+dfsg.orig.tar.xz
TERMUX_PKG_SHA256=0b536ff6c689973781f23fb9f9decb7f5ab902b39d57e1991789574de8d5ea5c
TERMUX_PKG_DEPENDS="ffmpeg, libexif, libflac, libid3tag, libjpeg-turbo, libsqlite, libvorbis"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="etc/minidlna.conf"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-log-path=$TERMUX_PREFIX/var/log
--with-db-path=$TERMUX_PREFIX/var/cache/minidlna
"

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/etc minidlna.conf
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/cache/minidlna
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then
	exit 0
	fi
	rm -rf $TERMUX_PREFIX/var/cache/minidlna
	EOF
}
