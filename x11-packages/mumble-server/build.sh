TERMUX_PKG_HOMEPAGE=https://www.mumble.info/
TERMUX_PKG_DESCRIPTION="Server module for Mumble, an open source voice-chat software"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.517
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/mumble-voip/mumble
TERMUX_PKG_DEPENDS="libc++, libcap, libdns-sd, libprotobuf, openssl, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dclient=OFF
-Dice=OFF
-Doverlay=OFF
-Dwarnings-as-errors=OFF
"
TERMUX_PKG_RM_AFTER_INSTALL="
etc/systemd
"

termux_step_pre_configure() {
	termux_setup_protobuf

	LDFLAGS+=" -lcap"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dprotobuf_PROTOC_EXE=$(command -v protoc)"
}

termux_step_post_make_install() {
	ln -sfT mumble-server $TERMUX_PREFIX/bin/murmurd
	install -Dm600 -t $TERMUX_PREFIX/share/doc/mumble-server/examples \
		$TERMUX_PKG_SRCDIR/auxiliary_files/mumble-server.ini
	chmod 0700 $TERMUX_PREFIX/bin/mumble-server-user-wrapper
}
