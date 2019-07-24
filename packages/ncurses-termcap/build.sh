TERMUX_PKG_HOMEPAGE=https://invisible-island.net/ncurses/
TERMUX_PKG_DESCRIPTION="Ncurses package with termcap and libtinfo"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=(6.1.20190511
		    9.22
		    15)
TERMUX_PKG_SHA256=(fdbd39234fc7e7f8e5fd08d2329014e085fa5c8d0a9cc9a919e94bbc9d411c0e
		   e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd
		   3ae9ebef28aad081c6c11351f086776e2fd9547563b2f900732b41c376bec05a)
TERMUX_PKG_SRCURL=(https://dl.bintray.com/termux/upstream/ncurses-${TERMUX_PKG_VERSION:0:3}-${TERMUX_PKG_VERSION:4}.tgz
		   https://fossies.org/linux/misc/rxvt-unicode-${TERMUX_PKG_VERSION[1]}.tar.bz2
		   https://github.com/thestinger/termite/archive/v${TERMUX_PKG_VERSION[2]}.tar.gz)

TERMUX_PKG_BREAKS="ncurses, ncurses-ui-libs, ncurses-utils"
TERMUX_PKG_REPLACES="ncurses, ncurses-ui-libs, ncurses-utils"
TERMUX_PKG_PROVIDES="ncurses, ncurses-ui-libs, ncurses-utils"
TERMUX_PKG_DEVPACKAGE_BREAKS="ncurses-dev"
TERMUX_PKG_DEVPACKAGE_REPLACES="ncurses-dev"

# --without-normal disables static libraries:
# --disable-stripping to disable -s argument to install which does not work when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
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
--without-normal
--without-static
--without-tests
--with-shared
--with-termlib
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="
share/man/man1/ncursesw6-config.1*
bin/ncursesw6-config
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5
share/man/man7
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	# we need the rm as we create(d) symlinks for the versioned so as well
	for lib in form menu ncurses panel tinfo; do
		rm -f lib${lib}.so*
		for file in lib${lib}w.so*; do
			ln -s $file ${file/w./.}
		done
		(cd pkgconfig; ln -sf ${lib}w.pc $lib.pc)
	done
	# some packages want libcurses while building/compiling
	rm -f libcurses.so*
	for file in libncurses.so*; do
		ln -s $file ${file/libn/lib}
	done

	# Some packages want these:
	cd $TERMUX_PREFIX/include/
	rm -Rf ncurses{,w}
	mkdir ncurses{,w}
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} ncurses
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} ncursesw
}

termux_step_post_massage() {
	# Strip away 30 years of cruft to decrease size.
	local TI=$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/terminfo
	mv $TI $TERMUX_PKG_TMPDIR/full-terminfo
	mkdir -p $TI/{a,d,e,n,l,p,r,s,t,v,x}
	cp $TERMUX_PKG_TMPDIR/full-terminfo/a/ansi $TI/a/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/d/{dtterm,dumb} $TI/d/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/e/eterm-color $TI/e/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/n/nsterm $TI/n/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/l/linux $TI/l/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/p/putty{,-256color} $TI/p/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/r/rxvt{,-256color} $TI/r/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/s/{screen{,2,-256color},st{,-256color}} $TI/s/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/t/tmux{,-256color} $TI/t/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/v/{vt52,vt100,vt102} $TI/v/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} $TI/x/

	tic -x -o $TI $TERMUX_PKG_SRCDIR/rxvt-unicode-${TERMUX_PKG_VERSION[1]}/doc/etc/rxvt-unicode.terminfo
	tic -x -o $TI $TERMUX_PKG_SRCDIR/termite-${TERMUX_PKG_VERSION[2]}/termite.terminfo
}
