TERMUX_PKG_HOMEPAGE=https://www.xiph.org/ao/
TERMUX_PKG_DESCRIPTION="A cross platform audio library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/xiph/libao/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d
TERMUX_PKG_DEPENDS="pulseaudio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-pulse"
TERMUX_PKG_CONFFILES="etc/libao.conf"

termux_step_pre_configure () {
	./autogen.sh
}

termux_step_post_make_install () {
	#generate libao config file
	mkdir -p $TERMUX_PREFIX/etc/
	cat << EOF > $TERMUX_PREFIX/etc/libao.conf
default_driver=pulse
buffer_time=50
quiet
EOF
}
