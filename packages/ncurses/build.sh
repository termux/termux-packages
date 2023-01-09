TERMUX_PKG_HOMEPAGE=https://invisible-island.net/ncurses/
TERMUX_PKG_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(6.4
		    9.30
		    15
		    0.26.5
		    0.9.0)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://ftp.gnu.org/gnu/ncurses/ncurses-${TERMUX_PKG_VERSION[0]}.tar.gz
		   https://fossies.org/linux/misc/rxvt-unicode-${TERMUX_PKG_VERSION[1]}.tar.bz2
		   https://github.com/thestinger/termite/archive/v${TERMUX_PKG_VERSION[2]}.tar.gz
		   https://github.com/kovidgoyal/kitty/archive/v${TERMUX_PKG_VERSION[3]}.tar.gz
		   https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION[4]}.tar.gz)
TERMUX_PKG_SHA256=(6931283d9ac87c5073f30b6290c4c75f21632bb4fc3603ac8100812bed248159
		   fe1c93d12f385876457a989fc3ae05c0915d2692efc59289d0f70fabe5b44d2d
		   3ae9ebef28aad081c6c11351f086776e2fd9547563b2f900732b41c376bec05a
		   7a1b444f1cc10e16ee0f20a804c0f80b52417eeabf60d9f25e37ef192503ba26
		   6d3aaac9e0477f903563b6fb26e089118407cdbfe952a1e2ffbf4e971b7062b3)
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

	# Some packages want these:
	cd $TERMUX_PREFIX/include/
	rm -Rf ncurses{,w}
	mkdir ncurses{,w}
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} ncurses
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} ncursesw

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
