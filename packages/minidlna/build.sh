TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/minidlna/
TERMUX_PKG_DESCRIPTION="A server software with the aim of being fully compliant with DLNA/UPnP-AV clients"
TERMUX_PKG_LICENSE="GPL-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENCE.miniupnpd"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://git.code.sf.net/p/minidlna/git
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION//./_}
TERMUX_PKG_DEPENDS="ffmpeg, libexif, libflac, libiconv, libid3tag, libjpeg-turbo, libogg, libsqlite, libvorbis"
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
