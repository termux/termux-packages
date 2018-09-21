TERMUX_PKG_HOMEPAGE=http://get.videolan.org
TERMUX_PKG_DESCRIPTION="video lan player"
TERMUX_PKG_VERSION=3.0.4
TERMUX_PKG_SRCURL=http://get.videolan.org/vlc/3.0.4/vlc-3.0.4.tar.xz
TERMUX_PKG_SHA256=01f3db3790714038c01f5e23c709e31ecd6f1c046ac93d19e1dde38b3fc05a9e
TERMUX_PKG_DEPENDS="libidn, libandroid-shmem, libsoxr"
#TERMUX_PKG_GCC8BUILD=yes
#TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-v4l2  --disable-lua   ac_cv_func_if_nameindex=yes ac_cv_func_if_nametoindex=yes --disable-xvideo --disable-xcb  --with-x=no  --disable-a52"
#TERMUX_PKG_HOSTBUILD=true
#TERMUX_PKG_CLANG=no

termux_step_pre_configure () {
	./bootstrap
	CFLAGS+="  -D__termux__"
	CXXFLAGS+=" -D__termux__"
	echo "" > /home/builder/.termux-build/vlc/src/modules/audio_output/audiotrack.c
	LDFLAGS+=" -landroid-shmem -llog"
	export ac_cv_func_if_nametoindex=yes
	export ac_cv_func_if_nameindex=yes
	export PROTOC=$TERMUX_TOPDIR/libprotobuf/host-build/src/protoc
}
