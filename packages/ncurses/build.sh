TERMUX_PKG_HOMEPAGE=https://invisible-island.net/ncurses/
TERMUX_PKG_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# This references a commit in https://github.com/ThomasDickey/ncurses-snapshots, specifically
# https://github.com/ThomasDickey/ncurses-snapshots/commit/${_SNAPSHOT_COMMIT}
# Check the commit description to see which version a commit belongs to - correct version
# is checked in termux_step_pre_configure(), so the build will fail on a mistake.
# Using this simplifies things (no need to avoid downloading and applying patches manually),
# and uses github is a high available hosting.
_SNAPSHOT_COMMIT=8bd5a3d98fc741bdcc9e5fada1a3d5980e1ea22a
TERMUX_PKG_VERSION=(6.4.20231001
                    9.31
                    15
                    0.31.0
                    0.11.0)
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=(https://github.com/ThomasDickey/ncurses-snapshots/archive/${_SNAPSHOT_COMMIT}.tar.gz
                   https://fossies.org/linux/misc/rxvt-unicode-${TERMUX_PKG_VERSION[1]}.tar.bz2
                   https://github.com/thestinger/termite/archive/v${TERMUX_PKG_VERSION[2]}.tar.gz
                   https://github.com/kovidgoyal/kitty/releases/download/v${TERMUX_PKG_VERSION[3]}/kitty-${TERMUX_PKG_VERSION[3]}.tar.xz
                   https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION[4]}.tar.gz)
TERMUX_PKG_SHA256=(ca4a28ed4d38a7b79e1cd883e3d2755839072a7e4fe8cf265be1ef4ae79b6bc2
                   aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8
                   3ae9ebef28aad081c6c11351f086776e2fd9547563b2f900732b41c376bec05a
                   d122497134abab8e25dfcb6b127af40cfe641980e007f696732f70ed298198f5
                   0fb3370c662f5b87d1b9a487aef999195212b192e08f6f68a572fed8fd637e07)
TERMUX_PKG_AUTO_UPDATE=false

# ncurses-utils: tset/reset/clear are moved to package 'ncurses'.
TERMUX_PKG_BREAKS="ncurses-dev, ncurses-utils (<< 6.1.20190511-4)"
TERMUX_PKG_REPLACES="ncurses-dev, ncurses-utils (<< 6.1.20190511-4)"

# --disable-stripping to disable -s argument to install which does not work when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
am_cv_langinfo_codeset=no
--disable-stripping
--enable-const
--enable-ext-colors
--enable-ext-mouse
--enable-overwrite
--enable-pc-files
--enable-termcap
--enable-widec
--mandir=$TERMUX_PREFIX/share/man
--without-ada
--without-cxx-binding
--without-debug
--without-tests
--with-normal
--with-pkg-config-libdir=$TERMUX_PREFIX/lib/pkgconfig
--with-static
--with-shared
--with-termpath=$TERMUX_PREFIX/etc/termcap:$TERMUX_PREFIX/share/misc/termcap
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5
share/man/man7
"

termux_step_pre_configure() {
	MAIN_VERSION=$(cut -f 2 VERSION)
	PATCH_VERSION=$(cut -f 3 VERSION)
	ACTUAL_VERSION=${MAIN_VERSION}.${PATCH_VERSION}
	EXPECTED_VERSION=${TERMUX_PKG_VERSION[0]}
	if [ "${ACTUAL_VERSION}" != "${EXPECTED_VERSION}"]; then
		termux_error_exit "Version mismatch - expected ${EXPECTED_VERSION}, was ${ACTUAL_VERSION}. Check https://github.com/ThomasDickey/ncurses-snapshots/commit/${_SNAPSHOT_COMMIT}"
	fi
	export CPPFLAGS+=" -fPIC"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib

	# Ncursesw/Ncurses compatibility symlinks.
	for lib in form menu ncurses panel; do
		ln -sfr lib${lib}w.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:3}
		ln -sfr lib${lib}w.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:1}
		ln -sfr lib${lib}w.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so
		ln -sfr lib${lib}w.a lib${lib}.a
		(cd pkgconfig; ln -sf ${lib}w.pc $lib.pc)
	done

	# Legacy compatibility symlinks (libcurses, libtermcap, libtic, libtinfo).
	for lib in curses termcap tic tinfo; do
		ln -sfr libncursesw.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:3}
		ln -sfr libncursesw.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:1}
		ln -sfr libncursesw.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so
		ln -sfr libncursesw.a lib${lib}.a
		(cd pkgconfig; ln -sfr ncursesw.pc ${lib}.pc)
	done

	# Strip away 30 years of cruft to decrease size.
	local TI=$TERMUX_PREFIX/share/terminfo
	mv $TI $TERMUX_PKG_TMPDIR/full-terminfo
	mkdir -p $TI/{a,d,e,g,n,k,l,p,r,s,t,v,x}
	cp $TERMUX_PKG_TMPDIR/full-terminfo/a/ansi $TI/a/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/d/{dtterm,dumb} $TI/d/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/e/eterm-color $TI/e/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/g/gnome{,-256color} $TI/g/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/n/nsterm $TI/n/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/k/kitty{,+common,-direct} $TI/k/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/l/linux $TI/l/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/p/putty{,-256color} $TI/p/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/r/rxvt{,-256color} $TI/r/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/s/{screen{,2,-256color},st{,-256color}} $TI/s/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/t/tmux{,-256color} $TI/t/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/v/{vt52,vt100,vt102} $TI/v/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} $TI/x/

	tic -x -o $TI $TERMUX_PKG_SRCDIR/rxvt-unicode-${TERMUX_PKG_VERSION[1]}/doc/etc/rxvt-unicode.terminfo
	tic -x -o $TI $TERMUX_PKG_SRCDIR/termite-${TERMUX_PKG_VERSION[2]}/termite.terminfo
	tic -x -o $TI $TERMUX_PKG_SRCDIR/kitty-${TERMUX_PKG_VERSION[3]}/terminfo/kitty.terminfo
	tic -x -o $TI $TERMUX_PKG_SRCDIR/alacritty-${TERMUX_PKG_VERSION[4]}/extra/alacritty.info
}

termux_step_post_massage() {
	# Some packages want these:
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include" || exit 1
	rm -Rf ncurses{,w}
	mkdir ncurses{,w}

	local _file
	for _file in *.h; do
		ln -s ../$_file ncurses
		ln -s ../$_file ncursesw
	done
}
