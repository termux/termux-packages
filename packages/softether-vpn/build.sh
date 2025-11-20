TERMUX_PKG_HOMEPAGE=https://www.softether.org/
TERMUX_PKG_DESCRIPTION="An open-source cross-platform multi-protocol VPN program"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(5.2.5188)
TERMUX_PKG_VERSION+=(1.0.20)
TERMUX_PKG_SRCURL=(https://github.com/SoftEtherVPN/SoftEtherVPN/releases/download/${TERMUX_PKG_VERSION}/SoftEtherVPN-${TERMUX_PKG_VERSION}.tar.xz
                   https://github.com/jedisct1/libsodium/archive/${TERMUX_PKG_VERSION[1]}-RELEASE.tar.gz)
TERMUX_PKG_SHA256=(e89278e7edd7e137bd521851b42c2bf9ce4e5cae2489db406588d3388646b147
                   8e5aeca07a723a27bbecc3beef14b0068d37e7fc0e97f51b3f1c82d2a58005c1)
TERMUX_PKG_DEPENDS="libiconv, libsodium, ncurses, openssl, readline, resolv-conf, zlib"
TERMUX_PKG_BUILD_DEPENDS="dos2unix"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAS_SSE2=OFF
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/systemd"

termux_step_post_get_source() {
	mv libsodium-${TERMUX_PKG_VERSION[1]}-RELEASE libsodium

	# convert CRLF to LF like in libpluto package
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		DOS2UNIX="$TERMUX_PKG_TMPDIR/dos2unix"
		(. "$TERMUX_SCRIPTDIR/packages/dos2unix/build.sh"; TERMUX_PKG_SRCDIR="$DOS2UNIX" termux_step_get_source)
		pushd "$DOS2UNIX"
		make dos2unix
		popd # DOS2UNIX
		export PATH="$DOS2UNIX:$PATH"
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 dos2unix
}

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD
	mkdir -p libsodium
	pushd libsodium
	$TERMUX_PKG_SRCDIR/libsodium/configure --prefix=$_PREFIX_FOR_BUILD
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
	popd

	export PKG_CONFIG_PATH=$_PREFIX_FOR_BUILD/lib/pkgconfig

	termux_setup_cmake
	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES

	unset PKG_CONFIG_PATH
}

termux_step_post_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/src/hamcorebuilder:$PATH
}
