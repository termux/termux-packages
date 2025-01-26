TERMUX_PKG_HOMEPAGE=https://tuxpaint.org/
TERMUX_PKG_DESCRIPTION="A free, award-winning drawing program for children ages 3 to 12"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.34"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/tuxpaint/tuxpaint-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b761df5ed386a9e04a6809ab3e0cbf2126f10b770527cb2b5f190ff5e370ed03
TERMUX_PKG_DEPENDS="fontconfig, fribidi, glib, libandroid-wordexp, libcairo, libimagequant, libpaper, libpng, librsvg, pango, sdl2 | sdl2-compat, sdl2-gfx, sdl2-image, sdl2-mixer, sdl2-pango, sdl2-ttf, zlib"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install install-xdg"

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix

	# Need imagemagick that can handle SVG format.
	local IMAGEMAGICK_BUILD_SH=$TERMUX_SCRIPTDIR/packages/imagemagick/build.sh
	local IMAGEMAGICK_SRCURL=$(. $IMAGEMAGICK_BUILD_SH; echo $TERMUX_PKG_SRCURL)
	local IMAGEMAGICK_SHA256=$(. $IMAGEMAGICK_BUILD_SH; echo $TERMUX_PKG_SHA256)
	local IMAGEMAGICK_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $IMAGEMAGICK_SRCURL)
	termux_download $IMAGEMAGICK_SRCURL $IMAGEMAGICK_TARFILE $IMAGEMAGICK_SHA256
	mkdir -p imagemagick
	cd imagemagick
	tar xf $IMAGEMAGICK_TARFILE --strip-components=1
	./configure --prefix=$_PREFIX_FOR_BUILD \
		--with-jpeg \
		--with-png \
		--with-rsvg
	make -j ${TERMUX_PKG_MAKE_PROCESSES} install
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", tuxpaint-data"

	local _PREFIX_FOR_BUILD="$TERMUX_PKG_HOSTBUILD_DIR/prefix"
	export PATH="$_PREFIX_FOR_BUILD/bin:$PATH"
	export XDG_DATA_HOME="$TERMUX_PREFIX/share" XDG_DATA_DIRS="$TERMUX_PREFIX" XDG_CURRENT_DESKTOP="X-Generic"

	# Disabling gtk-update-icon-cache
	ln -s /usr/bin/true "$_PREFIX_FOR_BUILD/bin/update-desktop-database" ||:
	ln -s /usr/bin/true "$_PREFIX_FOR_BUILD/bin/gtk-update-icon-cache" ||:

	CPPFLAGS+=" -U__ANDROID__"
	LDFLAGS+=" -landroid-wordexp"
}

termux_step_post_configure() {
	# https://github.com/termux/termux-packages/issues/12458
	mkdir -p trans
}

termux_step_post_make_install() {
	rm -rf $TERMUX_PREFIX/applications/mimeinfo.cache
}
