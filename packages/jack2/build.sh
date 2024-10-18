TERMUX_PKG_HOMEPAGE=https://jackaudio.org/
TERMUX_PKG_DESCRIPTION="The JACK low-latency audio server"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.9.22
TERMUX_PKG_SRCURL=https://github.com/jackaudio/jack2/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1e42b9fc4ad7db7befd414d45ab2f8a159c0b30fcd6eee452be662298766a849
TERMUX_PKG_DEPENDS="alsa-lib, dbus, libandroid-posix-semaphore, libdb, libexpat, libsamplerate, libopus"
# TERMUX_PKG_CONFLICTS="pipewire-jack"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	LDFLAGS+=" -landroid-posix-semaphore"
	python3 ./waf configure --alsa --classic --prefix="$TERMUX_PREFIX" --htmldir=$TERMUX_PREFIX/share/doc/jack2/html --firewire=no
}

termux_step_make() {
	python3 ./waf build
}

termux_step_make_install() {
	python3 ./waf install
}
