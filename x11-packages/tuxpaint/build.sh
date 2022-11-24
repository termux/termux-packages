TERMUX_PKG_HOMEPAGE=https://tuxpaint.org/
TERMUX_PKG_DESCRIPTION="A free, award-winning drawing program for children ages 3 to 12"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.28
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/tuxpaint/tuxpaint-${TERMUX_PKG_VERSION}-sdl1.tar.gz
TERMUX_PKG_SHA256=6f846ef46ab219fda3326336e2ccc65cedaf6d2c42c2f3e603ab601145a1868b
TERMUX_PKG_DEPENDS="fribidi, glib, libandroid-wordexp, libcairo, libimagequant, libpaper, libpng, librsvg, sdl, sdl-gfx, sdl-image, sdl-mixer, sdl-pango, sdl-ttf, tuxpaint-data, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix

	# Need imagemagick that can handle SVG format.
	local IMAGEMAGICK_BUILD_SH=$TERMUX_SCRIPTDIR/packages/imagemagick/build.sh
	local IMAGEMAGICK_SRCURL=$(bash -c ". $IMAGEMAGICK_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local IMAGEMAGICK_SHA256=$(bash -c ". $IMAGEMAGICK_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local IMAGEMAGICK_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $IMAGEMAGICK_SRCURL)
	termux_download $IMAGEMAGICK_SRCURL $IMAGEMAGICK_TARFILE $IMAGEMAGICK_SHA256
	mkdir -p imagemagick
	cd imagemagick
	tar xf $IMAGEMAGICK_TARFILE --strip-components=1
	./configure --prefix=$_PREFIX_FOR_BUILD \
		--with-jpeg \
		--with-png \
		--with-rsvg
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	export PATH=$_PREFIX_FOR_BUILD/bin:$PATH

	LDFLAGS+=" -landroid-wordexp"
}

termux_step_post_configure() {
	# https://github.com/termux/termux-packages/issues/12458
	mkdir -p trans
}
