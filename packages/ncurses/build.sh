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
_SNAPSHOT_COMMIT=5f58399b2de47ed14bdfe3a0cb149293b27893d5

# The subshell leaving the value in the outer scope unchanged is the point here.
# shellcheck disable=SC2031
TERMUX_PKG_VERSION=(6.6.20260124+really6.5.20250830
                    9.31
                    "$(. "$TERMUX_SCRIPTDIR/x11-packages/kitty/build.sh"; echo "$TERMUX_PKG_VERSION")"
                    "$(. "$TERMUX_SCRIPTDIR/x11-packages/alacritty/build.sh"; echo "$TERMUX_PKG_VERSION")"
                    "$(. "$TERMUX_SCRIPTDIR/x11-packages/foot/build.sh"; echo "$TERMUX_PKG_VERSION")")
# shellcheck disable=SC2031
TERMUX_PKG_SRCURL=("https://github.com/ThomasDickey/ncurses-snapshots/archive/${_SNAPSHOT_COMMIT}.tar.gz"
                   "https://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${TERMUX_PKG_VERSION[1]}.tar.bz2"
                   "$(. "$TERMUX_SCRIPTDIR/x11-packages/kitty/build.sh"; echo "$TERMUX_PKG_SRCURL")"
                   "$(. "$TERMUX_SCRIPTDIR/x11-packages/alacritty/build.sh"; echo "$TERMUX_PKG_SRCURL")"
                   "$(. "$TERMUX_SCRIPTDIR/x11-packages/foot/build.sh"; echo "$TERMUX_PKG_SRCURL")")
# shellcheck disable=SC2031
TERMUX_PKG_SHA256=(28cd102efe6a2610e830cc79cf270da6ff0427b2022900a9a36d2761522f9576
                   aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8
                   "$(. "$TERMUX_SCRIPTDIR/x11-packages/kitty/build.sh"; echo "$TERMUX_PKG_SHA256")"
                   "$(. "$TERMUX_SCRIPTDIR/x11-packages/alacritty/build.sh"; echo "$TERMUX_PKG_SHA256")"
                   "$(. "$TERMUX_SCRIPTDIR/x11-packages/foot/build.sh"; echo "$TERMUX_PKG_SHA256")")
TERMUX_PKG_AUTO_UPDATE=false

# ncurses-utils: tset/reset/clear are moved to package 'ncurses'.
TERMUX_PKG_BREAKS="ncurses-dev, ncurses-utils (<< 6.1.20190511-4)"
TERMUX_PKG_REPLACES="ncurses-dev, ncurses-utils (<< 6.1.20190511-4)"

# --disable-stripping to disable -s argument to install which does not work when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
am_cv_langinfo_codeset=no
--disable-opaque-panel
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

# shellcheck disable=SC2031
termux_step_pre_configure() {
	MAIN_VERSION="$(cut -f 2 VERSION)"
	PATCH_VERSION="$(cut -f 3 VERSION)"
	ACTUAL_VERSION="${MAIN_VERSION}.${PATCH_VERSION}"
	EXPECTED_VERSION="${TERMUX_PKG_VERSION[0]}"
	EXPECTED_VERSION="${EXPECTED_VERSION#*really}"
	if [[ "${ACTUAL_VERSION}" != "${EXPECTED_VERSION}" ]]; then
		termux_error_exit "Version mismatch - expected ${EXPECTED_VERSION}, was ${ACTUAL_VERSION}. Check https://github.com/ThomasDickey/ncurses-snapshots/commit/${_SNAPSHOT_COMMIT}"
	fi
	export CPPFLAGS+=" -fPIC"
}

# shellcheck disable=SC2031
termux_step_post_make_install() {
	cd "$TERMUX_PREFIX/lib" || termux_error_exit "Prefix 'lib' directory does not exist."

	local version="${TERMUX_PKG_VERSION[0]}"
	version="${version#*really}"

	# Ncursesw/Ncurses compatibility symlinks.
	for lib in form menu ncurses panel; do
		ln -sfr "lib${lib}w.so.${version:0:3}" "lib${lib}.so.${version:0:3}"
		ln -sfr "lib${lib}w.so.${version:0:3}" "lib${lib}.so.${version:0:1}"
		ln -sfr "lib${lib}w.so.${version:0:3}" "lib${lib}.so"
		ln -sfr "lib${lib}w.a" "lib${lib}.a"
		(cd pkgconfig; ln -sf "${lib}w.pc" "$lib.pc") || termux_error_exit "Failed to install comatibility symlink for '${lib}'"
	done

	# Legacy compatibility symlinks (libcurses, libtermcap, libtic, libtinfo).
	for lib in curses termcap tic tinfo; do
		ln -sfr "libncursesw.so.${version:0:3}" "lib${lib}.so.${version:0:3}"
		ln -sfr "libncursesw.so.${version:0:3}" "lib${lib}.so.${version:0:1}"
		ln -sfr "libncursesw.so.${version:0:3}" "lib${lib}.so"
		ln -sfr libncursesw.a "lib${lib}.a"
		(cd pkgconfig; ln -sfr ncursesw.pc "${lib}.pc") || termux_error_exit "Failed to install legacy comatibility symlink for '${lib}'"
	done

	# Some packages want these:
	cd "$TERMUX_PREFIX/include/" || termux_error_exit "Prefix 'include' directory does not exist."
	rm -Rf ncurses{,w}
	mkdir ncurses{,w}
	ln -s ../{curses.h,eti.h,form.h,menu.h,ncurses_dll.h,ncurses.h,panel.h,termcap.h,term_entry.h,term.h,unctrl.h} ncurses
	ln -s ../{curses.h,eti.h,form.h,menu.h,ncurses_dll.h,ncurses.h,panel.h,termcap.h,term_entry.h,term.h,unctrl.h} ncursesw

	# Strip away 30 years of cruft to decrease size.
	local TI="$TERMUX_PREFIX/share/terminfo"
	mv "$TI" "$TERMUX_PKG_TMPDIR/full-terminfo"
	mkdir -p "$TI"/{a,d,e,f,g,n,k,l,p,r,s,t,v,x}
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/a/{alacritty{,+common,-direct},ansi} "$TI/a/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/d/{dtterm,dumb} "$TI/d/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/e/eterm-color "$TI/e/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/f/foot{,+base,-direct} "$TI/f/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/g/gnome{,-256color} "$TI/g/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/n/nsterm "$TI/n/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/k/kitty{,+common,-direct} "$TI/k/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/l/linux "$TI/l/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/p/putty{,-256color} "$TI/p/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/r/rxvt{,-256color} "$TI/r/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/s/{screen{,2,-256color},st{,-256color}} "$TI/s/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/t/tmux{,-256color} "$TI/t/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/v/vt{52,100,102} "$TI/v/"
	cp "$TERMUX_PKG_TMPDIR"/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} "$TI/x/"

	tic -x -o "$TI" "$TERMUX_PKG_SRCDIR/rxvt-unicode-${TERMUX_PKG_VERSION[1]}/doc/etc/rxvt-unicode.terminfo"
	tic -x -o "$TI" "$TERMUX_PKG_SRCDIR/kitty-${TERMUX_PKG_VERSION[2]}/terminfo/kitty.terminfo"
	tic -x -e alacritty,alacritty+common,alacritty-direct -o "$TI" "$TERMUX_PKG_SRCDIR/alacritty-${TERMUX_PKG_VERSION[3]}/extra/alacritty.info"

	# Upstream instructions for building foot's terminfo
	# See: https://codeberg.org/dnkl/foot/src/branch/master/INSTALL.md#terminfo
	sed 's/@default_terminfo@/foot/g' "$TERMUX_PKG_SRCDIR/foot/foot.info" | \
	tic -x -e foot,foot-direct -o "$TI" -
}
