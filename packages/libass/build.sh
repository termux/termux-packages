TERMUX_PKG_HOMEPAGE=https://github.com/libass/libass
TERMUX_PKG_DESCRIPTION="libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format."
TERMUX_PKG_VERSION=0.14.0
TERMUX_PKG_MAINTAINER="lokesh @hax4us"
TERMUX_PKG_DEPENDS="freetype, fontconfig, harfbuzz, fribidi, libandroid-support"
TERMUX_PKG_BUILD_DEPENDS="pkg-config"
TERMUX_PKG_SHA256=8d5a5c920b90b70a108007ffcd2289ac652c0e03fc88e6eecefa37df0f2e7fdf
TERMUX_PKG_SRCURL=https://github.com/libass/libass/releases/download/${TERMUX_PKG_VERSION}/libass-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-static=no"
