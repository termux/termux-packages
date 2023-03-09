TERMUX_PKG_HOMEPAGE=https://godotengine.org
TERMUX_PKG_DESCRIPTION="Advanced cross-platform 2D and 3D game engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/godotengine/godot/archive/$TERMUX_PKG_VERSION-stable.tar.gz
TERMUX_PKG_SHA256=e6cf28411ae4196db0bcd608f77bcafc0c019ea6dd6cc8c750ca3cc3755df547
TERMUX_PKG_DEPENDS="ca-certificates, glu, libandroid-execinfo, libc++, libenet, libogg, libtheora, libvorbis, libvpx, libwebp, libwslay, libxcursor, libxi, libxinerama, libxkbcommon, libxrandr, mbedtls, miniupnpc, opengl, opusfile, pcre2, speechd, zstd, fontconfig"
TERMUX_PKG_BUILD_DEPENDS="pulseaudio, yasm"
TERMUX_PKG_PYTHON_COMMON_DEPS="scons"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local to_unbundle="libogg libtheora libvorbis libvpx libwebp mbedtls miniupnpc opus pcre2 wslay zstd enet"
	local system_libs=""
	for _lib in $to_unbundle; do
		rm -fr thirdparty/$_lib
		system_libs+="builtin_"$_lib"=no "
	done

	local _ARCH
	case $TERMUX_ARCH in
		aarch64) _ARCH=arm64;;
		arm) _ARCH=arm32;;
		x86_64) _ARCH=x86_64;;
		i686) _ARCH=x86_32;;
	esac

	export BUILD_NAME=termux
	scons -j$TERMUX_MAKE_PROCESSES \
		use_static_cpp=no \
		colored=yes \
		platform=linuxbsd \
		alsa=no \
		execinfo=yes \
		pulseaudio=yes \
		udev=no \
		arch=$_ARCH \
		system_certs_path=$TERMUX_PREFIX/etc/tls/cert.pem \
		use_llvm=yes \
		AR="$(command -v $AR)" \
		CC="$(command -v $CC)" \
		CXX="$(command -v $CXX)" \
		OBJCOPY="$(command -v $OBJCOPY)" \
		STRIP="$(command -v $STRIP)" \
		CFLAGS="$CPPFLAGS $CFLAGS" \
		CXXFLAGS="$CPPFLAGS $CXXFLAGS" \
		LINKFLAGS="$LDFLAGS" \
		CPPPATH="$TERMUX_PREFIX/include" \
		LIBPATH="$TERMUX_PREFIX/lib" \
		$system_libs \
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
