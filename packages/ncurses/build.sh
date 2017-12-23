TERMUX_PKG_HOMEPAGE=http://invisible-island.net/ncurses/
TERMUX_PKG_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
TERMUX_PKG_VERSION=6.0.20171216
TERMUX_PKG_SHA256=ef0189b3cad00d234f7f275cc98cc69e373f97ea598a6ba93cd99445e0603023
TERMUX_PKG_SRCURL=http://invisible-mirror.net/archives/ncurses/current/ncurses-${TERMUX_PKG_VERSION:0:3}-${TERMUX_PKG_VERSION:4}.tgz
# --without-normal disables static libraries:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
--enable-const
--enable-ext-colors
--enable-ext-mouse
--enable-overwrite
--enable-pc-files
--enable-widec
--mandir=$TERMUX_PREFIX/share/man
--without-ada
--without-cxx-binding
--without-debug
--without-normal
--without-static
--without-tests
--with-shared
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="
share/man/man1/ncursesw6-config.1*
bin/ncursesw6-config
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/captoinfo
bin/infotocap
share/man/man1/captoinfo.1*
share/man/man1/infotocap.1*
share/man/man5
share/man/man7
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/lib
	for lib in form menu ncurses panel; do
		for file in lib${lib}w.so*; do
			ln -s -f $file `echo $file | sed 's/w//'`
		done
		(cd pkgconfig && ln -s -f ${lib}w.pc `echo $lib | sed 's/w//'`.pc)
	done

	# Some packages wants this:
	cd $TERMUX_PREFIX/include/
	rm -Rf ncursesw
	mkdir ncursesw
	cd ncursesw
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} .
}

termux_step_post_massage () {
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
	cp $TERMUX_PKG_TMPDIR/full-terminfo/s/screen{,2,-256color} $TI/s/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/t/tmux{,-256color} $TI/t/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/v/{vt52,vt100,vt102} $TI/v/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} $TI/x/

	local RXVT_TAR=$TERMUX_PKG_CACHEDIR/rxvt-unicode-9.22.tar.bz2
	termux_download https://fossies.org/linux/misc/rxvt-unicode-9.22.tar.bz2 \
		$RXVT_TAR \
		e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd
	cd $TERMUX_PKG_TMPDIR
	local TI_FILE=rxvt-unicode-9.22/doc/etc/rxvt-unicode.terminfo
	tar xf $RXVT_TAR $TI_FILE
	tic -x -o $TI $TI_FILE
}
