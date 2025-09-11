TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="Tool to manipulate a limited range of multimedia formats and protocols without requiring excessive dependencies"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align version with `ffmpeg` package.
TERMUX_PKG_VERSION="7.1.1"
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=733984395e0dbbe5c046abda2dc49a5544e7e0e1e2366bba849222ae9e3a03b1
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_NO_STATICSPLIT="true"

termux_step_configure() {
	cd $TERMUX_PKG_BUILDDIR

	local _EXTRA_CONFIGURE_FLAGS=""
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		_ARCH="x86_64"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_ARCH="aarch64"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	$TERMUX_PKG_SRCDIR/configure \
		--arch="${_ARCH}" \
		--as="$AS" \
		--cc="$CC" \
		--cxx="$CXX" \
		--nm="$NM" \
		--ar="$AR" \
		--ranlib="llvm-ranlib" \
		--pkg-config="$PKG_CONFIG" \
		--strip="$STRIP" \
		--cross-prefix="${TERMUX_HOST_PLATFORM}-" \
		--disable-everything \
		--enable-cross-compile \
		--prefix="$TERMUX_PREFIX/opt/ffmpeg-minimal" \
		--target-os=android \
		--extra-libs="-landroid-glob" \
		$_EXTRA_CONFIGURE_FLAGS
}

termux_step_post_make_install() {
	local prog
	for prog in ffmpeg ffprobe; do
		ln -sfv "$TERMUX_PREFIX/opt/ffmpeg-minimal/bin/$prog" "$TERMUX_PREFIX/bin/$prog-minimal"
	done
}
