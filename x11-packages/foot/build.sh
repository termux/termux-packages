TERMUX_PKG_HOMEPAGE=https://codeberg.org/dnkl/foot
TERMUX_PKG_DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17.0"
TERMUX_PKG_SRCURL=https://codeberg.org/dnkl/foot/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ab5603edad89d26e8ae543e92c72210a1fbbe7abdf15a0729664b41baed6a3b8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, fontconfig, freetype, libfcft, libpixman, libwayland, libxkbcommon, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="libtllist, libwayland-protocols"

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"

	# libandroid-support provides this
	export CPPFLAGS+=" -D__STDC_ISO_10646__=201103L"
}
