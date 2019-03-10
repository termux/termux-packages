# Crashes with "Dungeon description not valid"
TERMUX_PKG_HOMEPAGE=http://sourceforge.net/apps/trac/unnethack
TERMUX_PKG_DESCRIPTION="Dungeon crawling game, fork of NetHack"
TERMUX_PKG_VERSION=5.1.0
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/unnethack/unnethack/${TERMUX_PKG_VERSION}/unnethack-${TERMUX_PKG_VERSION}-20131208.tar.gz
# --with-owner=$USER to avoid unnethack trying to use a "games" user, --with-groups to avoid "bin" group
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-owner=$USER --with-group=$(groups | cut -d ' ' -f 1)"
TERMUX_PKG_DEPENDS="gsl, ncurses"

# unnethack builds util/{makedefs,lev_comp,dgn_comp} binaries which are later used during the build.
# we first build these host tools in $TERMUX_PKG_TMPDIR/host-build and copy them into the ordinary
# cross compile tree after configure, bumping their modification time so that they do not get rebuilt.

CFLAGS="$CFLAGS $CPPFLAGS $LDFLAGS"
export LFLAGS="$LDFLAGS"
LD="$CC"

termux_step_pre_configure() {
	# Create a host build for the makedefs binary
	mkdir $TERMUX_PKG_TMPDIR/host-build
	cd $TERMUX_PKG_TMPDIR/host-build
	ORIG_CC=$CC; export CC=gcc
	ORIG_CFLAGS=$CFLAGS; export CFLAGS=""
	ORIG_CPPFLAGS=$CPPFLAGS; export CPPFLAGS=""
	ORIG_CXXFLAGS=$CXXFLAGS; export CXXFLAGS=""
	ORIG_LDFLAGS=$LDFLAGS; export LDFLAGS=""
	ORIG_LFLAGS=$LFLAGS; export LFLAGS=""
	$TERMUX_PKG_SRCDIR/configure --with-owner=$USER
	make
	make spec_levs
	make dungeon
	set +e
	make dlb
	set -e
	export CC=$ORIG_CC
	export CFLAGS=$ORIG_CFLAGS
	export CPPFLAGS=$ORIG_CPPFLAGS
	export CXXFLAGS=$ORIG_CXXFLAGS
	export LDFLAGS=$ORIG_LDFLAGS
	export LFLAGS=$ORIG_LFLAGS
}

termux_step_post_configure() {
	# Use the host built makedefs
	cp $TERMUX_PKG_TMPDIR/host-build/util/makedefs $TERMUX_PKG_BUILDDIR/util/makedefs
	cp $TERMUX_PKG_TMPDIR/host-build/util/lev_comp $TERMUX_PKG_BUILDDIR/util/lev_comp
	cp $TERMUX_PKG_TMPDIR/host-build/util/dgn_comp $TERMUX_PKG_BUILDDIR/util/dgn_comp
	cp $TERMUX_PKG_TMPDIR/host-build/util/dlb $TERMUX_PKG_BUILDDIR/util/dlb
	# Update timestamp so the binary does not get rebuilt
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/util/makedefs $TERMUX_PKG_BUILDDIR/util/lev_comp $TERMUX_PKG_BUILDDIR/util/dgn_comp $TERMUX_PKG_BUILDDIR/util/dlb
}

termux_step_post_make_install() {
	# Add directory which must exist:
	mkdir -p $TERMUX_PREFIX/var/unnethack/level
	echo "This directory stores locks" > $TERMUX_PREFIX/var/unnethack/level/README
}
