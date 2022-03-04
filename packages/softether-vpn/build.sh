TERMUX_PKG_HOMEPAGE=https://www.softether.org/
TERMUX_PKG_DESCRIPTION="An open-source cross-platform multi-protocol VPN program"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(5.02.5180)
TERMUX_PKG_REVISION=2
TERMUX_PKG_VERSION+=(1.0.18)
TERMUX_PKG_SRCURL=(https://github.com/SoftEtherVPN/SoftEtherVPN/releases/download/${TERMUX_PKG_VERSION}/SoftEtherVPN-${TERMUX_PKG_VERSION}.tar.xz
                   https://github.com/jedisct1/libsodium/archive/${TERMUX_PKG_VERSION[1]}-RELEASE.tar.gz)
TERMUX_PKG_SHA256=(b5649a8ea3cc6477325e09e2248ef708d434ee3b2251eb8764bcfc15fb1de456
                   b7292dd1da67a049c8e78415cd498ec138d194cfdb302e716b08d26b80fecc10)
TERMUX_PKG_DEPENDS="libiconv, libsodium, ncurses, openssl, readline, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAS_SSE2=OFF
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/systemd"

termux_step_post_get_source() {
	mv libsodium-${TERMUX_PKG_VERSION[1]}-RELEASE libsodium
}

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD
	mkdir -p libsodium
	pushd libsodium
	$TERMUX_PKG_SRCDIR/libsodium/configure --prefix=$_PREFIX_FOR_BUILD
	make -j $TERMUX_MAKE_PROCESSES
	make install
	popd

	export PKG_CONFIG_PATH=$_PREFIX_FOR_BUILD/lib/pkgconfig

	termux_setup_cmake
	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_MAKE_PROCESSES

	unset PKG_CONFIG_PATH
}

termux_step_post_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/src/hamcorebuilder:$PATH
}
