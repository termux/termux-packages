TERMUX_PKG_HOMEPAGE=https://www.mumble.info/
TERMUX_PKG_DESCRIPTION="Server module for Mumble, an open source voice-chat software"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.287
TERMUX_PKG_SRCURL=https://github.com/mumble-voip/mumble.git
TERMUX_PKG_DEPENDS="libc++, libcap, libdns-sd, libprotobuf, openssl-1.1, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dclient=OFF
-Dice=OFF
-Doverlay=OFF
-Dwarnings-as-errors=OFF
-DOPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
-DOPENSSL_LIBRARIES=$TERMUX_PREFIX/lib/openssl-1.1
-DOPENSSL_CRYPTO_LIBRARY=$TERMUX_PREFIX/lib/openssl-1.1/libcrypto.so.1.1
-DOPENSSL_SSL_LIBRARY=$TERMUX_PREFIX/lib/openssl-1.1/libssl.so.1.1
"

termux_step_pre_configure() {
	termux_setup_protobuf

	LDFLAGS+=" -lcap"

	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"
	

}

termux_step_post_configure() {
	if [ "$TERMUX_CMAKE_BUILD" == "Ninja" ]; then
		sed -i s:${TERMUX_PREFIX//./\\.}'/bin/protoc[0-9.-]*:'$(command -v protoc):g \
			build.ninja
	fi
}

termux_step_post_make_install() {
	ln -sfT mumble-server $TERMUX_PREFIX/bin/murmurd
	cd $TERMUX_PKG_SRCDIR/scripts
	install -Dm600 -t $TERMUX_PREFIX/etc/dbus-1/system.d murmur.conf
	install -Dm600 -t $TERMUX_PREFIX/etc murmur.ini
	install -Dm700 -t $TERMUX_PREFIX/bin mumble-server-user-wrapper
	install -Dm600 -t $TERMUX_PREFIX/share/doc/mumble-server/examples murmur.ini
}
