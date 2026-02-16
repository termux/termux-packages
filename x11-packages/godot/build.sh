TERMUX_PKG_HOMEPAGE=https://godotengine.org
TERMUX_PKG_DESCRIPTION="Advanced cross-platform 2D and 3D game engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.1"
TERMUX_PKG_SRCURL="https://github.com/godotengine/godot/archive/refs/tags/$TERMUX_PKG_VERSION-stable.tar.gz"
TERMUX_PKG_SHA256=f5d887cda2589fd2995b1cf7e74fe1ec54220f56d7fd6729a8a0865d794fb287
TERMUX_PKG_DEPENDS="brotli, ca-certificates, fontconfig, freetype, glu, libandroid-execinfo, libc++, libenet, libgraphite, libjpeg-turbo, libogg, libtheora, libvorbis, libvpx, libwebp, libwslay, libxcursor, libxi, libxinerama, libxkbcommon, libxrandr, mbedtls, miniupnpc, opengl, opusfile, pcre2, sdl3, speechd, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="pulseaudio, yasm"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="scons"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+(\.\d+)?(?=-stable)'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local to_unbundle="" system_libs=""

	to_unbundle+="brotli "
	to_unbundle+="enet "
	to_unbundle+="freetype "
	to_unbundle+="graphite "
	to_unbundle+="libjpeg-turbo "
	to_unbundle+="libogg "
	to_unbundle+="libtheora "
	to_unbundle+="libvorbis "
	to_unbundle+="libvpx "
	to_unbundle+="libwebp "
	to_unbundle+="mbedtls "
	to_unbundle+="miniupnpc "
	to_unbundle+="opus "
	to_unbundle+="pcre2 "
	to_unbundle+="sdl "
	to_unbundle+="wslay "
	to_unbundle+="zlib "
	to_unbundle+="zstd "

	for _lib in $to_unbundle; do
		rm -fr thirdparty/$_lib
		system_libs+="builtin_${_lib//-/_}=no "
	done

	echo "$system_libs"

	local _ARCH
	case $TERMUX_ARCH in
		aarch64) _ARCH=arm64;;
		arm) _ARCH=arm32;;
		x86_64) _ARCH=x86_64;;
		i686) _ARCH=x86_32;;
	esac

	local debug=""
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		# godot has a lot of possible weird debug settings,
		# so if TERMUX_DEBUG_BUILD=true, enable a sane set
		# of two that seem appropriate and compatible with
		# the typical termux package debugging workflow
		debug+="debug_symbols=yes "
		debug+="optimize=debug "
	fi

	export BUILD_NAME=termux
	scons -j$TERMUX_PKG_MAKE_PROCESSES \
		use_static_cpp=no \
		colored=yes \
		platform=linuxbsd \
		alsa=no \
		execinfo=yes \
		pulseaudio=yes \
		udev=no \
		module_camera_enabled=no \
		arch=$_ARCH \
		system_certs_path=$TERMUX_PREFIX/etc/tls/cert.pem \
		use_llvm=yes \
		AR="$(command -v $AR)" \
		CC="$(command -v $CC)" \
		CXX="$(command -v $CXX)" \
		OBJCOPY="$(command -v $OBJCOPY)" \
		STRIP="$(command -v $STRIP)" \
		cflags="$CPPFLAGS $CFLAGS" \
		cxxflags="$CPPFLAGS $CXXFLAGS" \
		linkflags="$LDFLAGS -landroid-execinfo -lturbojpeg" \
		CPPPATH="$TERMUX_PREFIX/include" \
		LIBPATH="$TERMUX_PREFIX/lib" \
		$system_libs \
		$debug \
		verbose=1

	mv $TERMUX_PKG_BUILDDIR/bin/godot.linuxbsd.editor.$_ARCH.llvm $TERMUX_PKG_BUILDDIR/bin/godot.linuxbsd.editor.llvm
}

termux_step_make_install() {
	install -Dm644 misc/dist/linux/org.godotengine.Godot.desktop $TERMUX_PREFIX/share/applications/godot.desktop
	install -Dm644 icon.svg $TERMUX_PREFIX/share/pixmaps/godot.svg
	install -Dm644 LICENSE.txt $TERMUX_PREFIX/share/licenses/godot/LICENSE
	install -Dm755 $TERMUX_PKG_BUILDDIR/bin/godot.linuxbsd.editor.llvm $TERMUX_PREFIX/bin/godot
	install -Dm644 $TERMUX_PKG_BUILDDIR/misc/dist/linux/godot.6 $TERMUX_PREFIX/share/man/man6/godot.6
	install -Dm644 $TERMUX_PKG_BUILDDIR/misc/dist/linux/org.godotengine.Godot.xml $TERMUX_PREFIX/share/mime/packages/org.godotengine.Godot.xml
}
