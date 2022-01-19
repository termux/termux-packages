TERMUX_PKG_HOMEPAGE=https://www.mono-project.com/
TERMUX_PKG_DESCRIPTION="Cross platform, open source .NET framework"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.12.0.122
TERMUX_PKG_SRCURL=https://download.mono-project.com/sources/mono/mono-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=29c277660fc5e7513107aee1cbf8c5057c9370a4cdfeda2fc781be6986d89d23
TERMUX_PKG_DEPENDS="krb5, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-btls
--without-ikvm-native
"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	rm -f external/bdwgc/config.status
}

termux_step_host_build() {
	_PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/_prefix
	mkdir -p $_PREFIX_FOR_BUILD
	$TERMUX_PKG_SRCDIR/configure --prefix=$_PREFIX_FOR_BUILD \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "arm" ]; then
		CFLAGS="${CFLAGS//-mthumb/}"
	fi
	LDFLAGS+=" -lgssapi_krb5"
}

termux_step_post_make_install() {
	find $_PREFIX_FOR_BUILD/lib/mono -name '*.so' -exec rm -f \{\} \;
	cp -rT $_PREFIX_FOR_BUILD/lib/mono $TERMUX_PREFIX/lib/mono
}
