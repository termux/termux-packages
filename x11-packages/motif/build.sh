TERMUX_PKG_HOMEPAGE=https://github.com/thentenaar/motif
TERMUX_PKG_DESCRIPTION="Motif widget toolkit"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.2
TERMUX_PKG_SRCURL=(
	https://github.com/thentenaar/motif/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
	https://xorg.freedesktop.org/releases/individual/lib/libXpm-3.5.19.tar.xz
	https://xorg.freedesktop.org/releases/individual/lib/libXmu-1.3.1.tar.xz
)
TERMUX_PKG_SHA256=(
	6698f72e2018eaebb810c8a47345fc8a40a3f945551380ce88a0da6c434a010a
	ad3576d689221a39dc728f0e0dc02ca7bb6a0d724c9a77fd1bfa1e9af83be900
	81a99e94c4501e81c427cbaa4a11748b584933e94b7a156830c3621256857bc4
)
TERMUX_PKG_DEPENDS="fontconfig, freetype, libandroid-support, libice, libiconv, libjpeg-turbo, libpng, libsm, libx11, libxcursor, libxext, libxft, libxmu, libxpm, libxrandr, libxrender, libxt"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="flex, xbitmaps, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-demos
--disable-tests
"
TERMUX_PKG_MAKE_PROCESSES=1
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local _ABI_CURRENT="$(sed -n 's/^m4_define(\[ABI_CURRENT\],\s*\[\([0-9]*\)\])/\1/p' configure.ac)"
	local _ABI_AGE="$(sed -n 's/^m4_define(\[ABI_AGE\],\s*\[\([0-9]*\)\])/\1/p' configure.ac)"
	local v=$(( _ABI_CURRENT - _ABI_AGE ))
	if [ ! "${_ABI_CURRENT}" ] || [ ! "${_ABI_AGE}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	autoreconf -fi
}

termux_step_host_build() {
	local _prefix=$TERMUX_PKG_HOSTBUILD_DIR/prefix _url _lib
	for _url in "${TERMUX_PKG_SRCURL[@]:1}"; do
		_lib=$(basename "$_url" .tar.xz)
		mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/$_lib
		(
			cd $TERMUX_PKG_HOSTBUILD_DIR/$_lib
			PKG_CONFIG_PATH=$_prefix/lib/pkgconfig $TERMUX_PKG_SRCDIR/$_lib/configure --prefix=$_prefix --disable-static
			make -j $TERMUX_PKG_MAKE_PROCESSES install
		)
	done

	(
		export PKG_CONFIG_PATH=$_prefix/lib/pkgconfig
		export LD_LIBRARY_PATH=$_prefix/lib
		"$TERMUX_PKG_SRCDIR/configure" \
			--disable-demos --disable-tests \
			--without-jpeg --without-png --without-xft \
			--without-xrandr --without-xrender --without-xcursor

		make -C config
		make -C lib/Xm
		make -C tools/wml
	)
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/config:$TERMUX_PKG_HOSTBUILD_DIR/tools/wml:$PATH
	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/prefix/lib
	autoreconf -fi
}
