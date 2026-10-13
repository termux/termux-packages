TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="FFplay media player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `ffmpeg` package.
TERMUX_PKG_VERSION="8.1.3"
TERMUX_PKG_SRCURL="https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7138d28c96d9d3e3af4ee3d8cad72741f8ffb40da90c1112235dea3ecd3178a3
TERMUX_PKG_DEPENDS="ffmpeg, libandroid-shmem, libmysofa, libx11, libxcb, libxext, libxv, pulseaudio, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"

termux_step_pre_configure() {
	_FFPLAY_PREFIX="$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME"
	LDFLAGS="-Wl,-rpath=${_FFPLAY_PREFIX}/lib $LDFLAGS -landroid-shmem"
}

termux_step_configure() {
	local _ARCH
	case "$TERMUX_ARCH" in
		"arm") _ARCH=armeabi-v7a ;;
		"i686") _ARCH=x86 ;;
		*) _ARCH="$TERMUX_ARCH" ;;
	esac

	"$TERMUX_PKG_SRCDIR/configure" \
		--prefix="${_FFPLAY_PREFIX}" \
		--cc="$CC" \
		--pkg-config="$PKG_CONFIG" \
		--arch="${_ARCH}" \
		--cross-prefix=llvm- \
		--enable-cross-compile \
		--target-os=android \
		--disable-version3 \
		--disable-static \
		--enable-shared \
		--disable-autodetect \
		--disable-doc \
		--disable-asm \
		--enable-libmysofa \
		--enable-libpulse \
		--enable-libxcb \
		--enable-libxcb-shm \
		--enable-libxcb-xfixes \
		--enable-libxcb-shape \
		--enable-sdl \
		--enable-xlib \
		--enable-ffplay
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/bin"
	ln -sfr "${_FFPLAY_PREFIX}/bin/ffplay" "$TERMUX_PREFIX/bin/"
}

termux_step_post_massage() {
	cd "$TERMUX_PKG_MASSAGEDIR/${_FFPLAY_PREFIX}" || exit 1
	find . ! -type d \
		! -wholename "./bin/ffplay" \
		! -wholename "./lib/libavdevice.so*" \
		-exec rm -f '{}' \;
	find . -type d -empty -delete
}
