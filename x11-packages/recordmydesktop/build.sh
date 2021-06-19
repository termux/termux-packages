TERMUX_PKG_HOMEPAGE=http://recordmydesktop.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Produces a OGG encapsulated Theora/Vorbis recording of your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.3.8.1
TERMUX_PKG_REVISION=20
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/recordmydesktop/recordmydesktop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33a2e208186ae78e2db2a27b0f5047b50fb7819c47fe15483b0765200b9d738c
TERMUX_PKG_DEPENDS="libandroid-shmem, libsm, libtheora, libvorbis, libxdamage, libxext, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pthread_pthread_mutex_lock=yes
--enable-oss=no
--enable-jack=no
"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}
