TERMUX_PKG_HOMEPAGE=https://chromium.googlesource.com/webm/libwebp
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL=https://github.com/webmproject/libwebp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e1bd8b81098b8094edba0f161baf89f9fb1492e3fca19cf1d28eff4b88518702
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DEPENDS="libpng, libjpeg-turbo, libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-png
--enable-tiff
--enable-jpeg
--enable-libwebpmux
--enable-libwebpdemux
--enable-libwebpdecoder
--enable-libwebpextras
"

termux_step_pre_configure () {
	CPPFLAGS="$CPPFLAGS -I$NDK/sources/android/cpufeatures"
	$CC -c -o $TERMUX_PKG_BUILDDIR/libcpufeatures.o $CPPFLAGS $CFLAGS $NDK/sources/android/cpufeatures/cpu-features.c
	$AR rcs $TERMUX_PKG_BUILDDIR/libcpufeatures.a $TERMUX_PKG_BUILDDIR/libcpufeatures.o
	LDFLAGS="$LDFLAGS -l$TERMUX_PKG_BUILDDIR/libcpufeatures.a"

	autoreconf -fi
}
