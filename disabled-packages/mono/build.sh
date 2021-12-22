TERMUX_PKG_HOMEPAGE=http://www.mono-project.com/
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
_MONO_VERSION=5.0.0
_MONO_PATCH=100
TERMUX_PKG_VERSION=$_MONO_VERSION.$_MONO_PATCH
# official package is missing support/libm/math_private.h
#TERMUX_PKG_SRCURL=https://github.com/mono/mono/archive/mono-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SRCURL=https://download.mono-project.com/sources/mono/mono-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=368da3ff9f42592920cd8cf6fa15c6c16558e967144c4d3df873352e5d2bb6df
TERMUX_PKG_FOLDERNAME=mono-$_MONO_VERSION
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS='--disable-mcs-build --disable-boehm --with-sigaltstack=no'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="--disable-btls --disable-dynamic-btls" #--with-btls-android-ndk=$ANDROID_NDK"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
#	export CFLAGS="$CFLAGS -mthumb"
	cd "$TERMUX_PKG_SRCDIR"
#	NOCONFIGURE=1 ./autogen.sh
#	cp $TERMUX_PKG_BUILDER_DIR/{complex,math_private}.h $TERMUX_PKG_SRCDIR/support/libm/
	export ANDROID_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN
}

