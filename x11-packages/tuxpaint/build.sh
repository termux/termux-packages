TERMUX_PKG_HOMEPAGE=https://tuxpaint.org/
TERMUX_PKG_DESCRIPTION="A free, award-winning drawing program for children ages 3 to 12"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.32"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/tuxpaint/tuxpaint-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=09cce22241481dc1360fc4bc5d4da1d31815d7a2563b9e9fa217a672ba974bf2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fribidi, libandroid-wordexp, libcairo, libimagequant, libpaper, libpng, librsvg, sdl2, sdl2-gfx, sdl2-image, sdl2-mixer, sdl2-pango, sdl2-ttf, tuxpaint-data, zlib"
TERMUX_PKG_BUILD_DEPENDS="glib"
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
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	export PATH=$_PREFIX_FOR_BUILD/bin:$PATH

	CPPFLAGS+=" -U__ANDROID__"
	LDFLAGS+=" -landroid-wordexp"
}

termux_step_post_configure() {
	# https://github.com/termux/termux-packages/issues/12458
	mkdir -p trans
}
