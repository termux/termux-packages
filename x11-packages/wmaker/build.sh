TERMUX_PKG_HOMEPAGE=https://www.windowmaker.org/
TERMUX_PKG_DESCRIPTION="An X11 window manager that reproduces the look and feel of the NeXTSTEP user interface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.96.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/window-maker/wmaker/releases/download/wmaker-${TERMUX_PKG_VERSION}/WindowMaker-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fe130ba23cf4aa21c156ec8f01f748df537d0604ec06c6bbcec896df1926f6d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="fontconfig, freetype, giflib, glib, harfbuzz, imagemagick, libandroid-shmem, libexif, libjpeg-turbo, libpng, libtiff, libwebp, libx11, libxext, libxft, libxinerama, libxmu, libxpm, pango"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-pango
--x-includes=${TERMUX_PREFIX}/include
--x-libraries=${TERMUX_PREFIX}/lib"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
	export CFLAGS="$CFLAGS -I${TERMUX_PKG_BUILDDIR}/WINGs"
	export LDFLAGS="$LDFLAGS -static-openmp"
}
