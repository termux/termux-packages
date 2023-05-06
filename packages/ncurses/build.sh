TERMUX_PKG_HOMEPAGE=https://invisible-island.net/ncurses/
TERMUX_PKG_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_MAIN_VERSION=6.4
TERMUX_PKG_VERSION=(${_MAIN_VERSION}.20230527
		    9.31
		    15
		    0.26.5
		    0.11.0)
TERMUX_PKG_SRCURL=(https://ftp.gnu.org/gnu/ncurses/ncurses-${_MAIN_VERSION}.tar.gz
		   https://fossies.org/linux/misc/rxvt-unicode-${TERMUX_PKG_VERSION[1]}.tar.bz2
		   https://github.com/thestinger/termite/archive/v${TERMUX_PKG_VERSION[2]}.tar.gz
		   https://github.com/kovidgoyal/kitty/archive/v${TERMUX_PKG_VERSION[3]}.tar.gz
		   https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION[4]}.tar.gz)
TERMUX_PKG_SHA256=(6931283d9ac87c5073f30b6290c4c75f21632bb4fc3603ac8100812bed248159
		   aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8
		   3ae9ebef28aad081c6c11351f086776e2fd9547563b2f900732b41c376bec05a
		   7a1b444f1cc10e16ee0f20a804c0f80b52417eeabf60d9f25e37ef192503ba26
		   0fb3370c662f5b87d1b9a487aef999195212b192e08f6f68a572fed8fd637e07)
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

termux_step_post_get_source() {
	# Array of strings of the form "PATCH_DATE PATCH_SHA256":
	local _PATCHES=()
	# Example:
	# _PATCHES+=("00000000 0000000000000000000000000000000000000000000000000000000000000000")

	_PATCHES+=("20230107 5db8fd0f61d8cff5109e9fb64de0f072e46575bae11964315d7ccd1effe342ba")
	_PATCHES+=("20230114 91b93e5a7ec8e9f8a9950ae9b2c19409813df418c35f4a9adc987425ebb0c22a")
	_PATCHES+=("20230121 95bf1d1144920d3d6362d38b576ae69392707d566ab430f15a10de19ad1f08b2")
	_PATCHES+=("20230128 9127ae1eb6045462e36eb88b416dd6a309d31bac93cee46cbbb2037e7a4ea820")
	_PATCHES+=("20230211 48a74d781baa8e88470534d4a20e72a54058b444b6a48e9e19517f00645cd471")
	_PATCHES+=("20230218 3885ad9afee7e1123262c7b845210e6a67e045b4eee1456c10be0c177f2252da")
	_PATCHES+=("20230225 38eeca8a155d294ef4e3f3b0989599fe325f8a94c131f8b206caac0d30bd6d11")
	_PATCHES+=("20230311 402e587caa1dc11b1458306d91d6ac9b1d6e8d7eaba3505df96cf5e995255cd5")
	_PATCHES+=("20230401 ae9a7fc9891efb3eedf5898287591854fac5f16bc320ba2c8a19222d32649764")
	_PATCHES+=("20230408 325dceaea1c0bf52f0a8dd40246313f858494845268e964cd9d0da6ba35d52f0")
	_PATCHES+=("20230415 bd0b69a5f5678ef68ba5b554048bc517fb4ba14d8648e73e49849653bd8a66ab")
	_PATCHES+=("20230418 5876fb8a852a1d03e85eb625c5945001764836f85a07742d7b20307e2b14466a")
	_PATCHES+=("20230423 32637e52472eb35c2ed8959b09262d9fe3c67c1f056be768a83b4dffe07f9324")
	_PATCHES+=("20230424 ba00a9ca08f19c6d3f93832924ace31a3da090c1d73f015708eafb0b1c3c6181")
	_PATCHES+=("20230429 e13b5c1c17a1c04f789177f7d73aaa74fbca33e23859327b3524445378b61020")
	_PATCHES+=("20230506 2a10a6e8829a9d5a41a5973b09110de0d6112214806a2efe50ccc37b89a766be")
	_PATCHES+=("20230514 9a7246c78c4ddbeb1951e50df2d3c8a339ceecba40e37fa393ec39db45c8df86")
	_PATCHES+=("20230520 0c72a0a9fd256b64daf0798436cb9d7e537849a1bc45164c0f7aa0f85de33ed0")
	_PATCHES+=("20230527 a317760baecd00924b69a7cad5833370b1ceda02d51ec660a46de93bef3827df")

	local _NUM_PATCHES=${#_PATCHES[@]}
	local _PATCH_VERSION=$(echo ${TERMUX_PKG_VERSION[0]} | cut -d . -f 3)
	if [ -z "${_PATCH_VERSION}" ]; then
		return
	fi
	# TERMUX_PKG_VERSION is assumed to include patchlevel.
	if [ "${_NUM_PATCHES}" = 0 ]; then
		termux_error_exit "No patch is specified whereas TERMUX_PKG_VERSION includes patchlevel."
	fi
	if [ "$(echo ${_PATCHES[_NUM_PATCHES-1]} | cut -d ' ' -f 1)" != "${_PATCH_VERSION}" ]; then
		termux_error_exit "Specified patches do not match with TERMUX_PKG_VERSION."
	fi
	local _MAIN_VERSION=$(echo ${TERMUX_PKG_VERSION[0]} | cut -d . -f 1-2)
	local i
	for i in $(seq 0 $((_NUM_PATCHES-1))); do
		local _patch_date=$(echo ${_PATCHES[i]} | cut -d ' ' -f 1)
		local _patch_sha256=$(echo ${_PATCHES[i]} | cut -d ' ' -f 2)
		local _patch_filename="ncurses-${_MAIN_VERSION}-${_patch_date}.patch.gz"
		# We do not use upstream URL
		# "https://invisible-island.net/archives/ncurses/${_MAIN_VERSION}/${_patch_filename}"
		# which is not suitable for CI due to bad responsiveness.
		termux_download \
			"https://ftp-osl.osuosl.org/pub/gentoo/distfiles/${_patch_filename}" \
			"$TERMUX_PKG_CACHEDIR/${_patch_filename}" \
			"${_patch_sha256}"
		echo "Applying ${_patch_filename}"
		zcat "$TERMUX_PKG_CACHEDIR/${_patch_filename}" | \
			patch --silent -p1
	done
}

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
