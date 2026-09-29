TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/myman/
TERMUX_PKG_DESCRIPTION="Video game for color and monochrome text terminals in the genre of Namco's Pac-Man"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/myman/files/myman-cvs/myman-cvs-2009-10-30/myman-cvs-2009-10-30.tar.gz
TERMUX_PKG_SHA256=253e22f26dc95c63388bc4cb81075a05f77f7709d1d64ed9fde7aae38a7fc962
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_HOSTBUILD=true
# myman is installed twice for no reason
TERMUX_PKG_RM_AFTER_INSTALL="bin/myman-$TERMUX_PKG_VERSION"
TERMUX_PKG_GROUPS="games"

termux_step_get_source() {
	cd $TERMUX_PKG_CACHEDIR
	termux_download "${TERMUX_PKG_SRCURL}" "$(basename ${TERMUX_PKG_SRCURL})" "${TERMUX_PKG_SHA256}"
	tar -xf "$(basename ${TERMUX_PKG_SRCURL})"
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cvs -d$TERMUX_PKG_CACHEDIR/myman-cvs co -P myman
	mv myman/* .
}

termux_step_host_build() {
	$TERMUX_PKG_SRCDIR/configure
	make obj/s1game
}

termux_step_post_configure() {
	mkdir -p obj
	cp $TERMUX_PKG_HOSTBUILD_DIR/obj/s1game obj/
	touch -d "next hour" obj/s1game
}
