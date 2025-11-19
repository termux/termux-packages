TERMUX_PKG_HOMEPAGE=https://zmap.io/
TERMUX_PKG_DESCRIPTION="A fast single packet network scanner designed for Internet-wide network surveys"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(1:4.3.2
                    1.0.5)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://github.com/zmap/zmap/archive/refs/tags/v${TERMUX_PKG_VERSION[0]#*:}.tar.gz
                   http://downloads.sourceforge.net/sourceforge/judy/Judy-${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(2f1e031d07d9c7040bf75aa58e258c311985e2b32dbb9a375e0d1c31bcedbf0a
                   d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb)
TERMUX_PKG_DEPENDS="json-c, libgmp, libpcap, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DRESPECT_INSTALL_PREFIX_CONFIG=ON
"

termux_step_pre_configure() {
	local _PREFIX="$TERMUX_PKG_TMPDIR/prefix"
	export PKG_CONFIG_PATH="$_PREFIX/lib/pkgconfig"
	CFLAGS+=" -I${_PREFIX}/include/"
	(
		# Judy is not used anywhere else.
		# Build it in subshell to not mess with variables.
		TERMUX_PKG_SRCDIR+="/judy-${TERMUX_PKG_VERSION[1]}"
		TERMUX_PKG_BUILDDIR+="/judy-${TERMUX_PKG_VERSION[1]}"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-shared --enable-static --prefix=$_PREFIX"
		# Can not be built in multithreaded mode.
		TERMUX_PKG_MAKE_PROCESSES=1

		rm -rf "$_PREFIX"
		mkdir -p "$_PREFIX"
		cd "$TERMUX_PKG_SRCDIR"
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			local JU_64BIT="$([ "$TERMUX_ARCH_BITS" = 64 ] && echo "-DJU_64BIT")"
			sed 's/@JU_64BIT@/'$JU_64BIT'/g' $TERMUX_PKG_BUILDER_DIR/hostbuild.diff | patch -Np1
		fi
		termux_step_configure
		termux_step_make
		termux_step_make_install
	)
}
