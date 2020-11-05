TERMUX_PKG_HOMEPAGE=https://github.com/azatoth/minidlna
TERMUX_PKG_DESCRIPTION="A server software with the aim of being fully compliant with DLNA/UPnP-AV clients"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/m/minidlna/minidlna_${TERMUX_PKG_VERSION}+dfsg.orig.tar.xz
TERMUX_PKG_SHA256=72f688c4dd0412fb7a9389bf4ade3bad773924eae9cb31f510440414af3785a0
TERMUX_PKG_DEPENDS="ffmpeg, libexif, libflac, libid3tag, libjpeg-turbo, libsqlite, libvorbis"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	./autogen.sh
}
