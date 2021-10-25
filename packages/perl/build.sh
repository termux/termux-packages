TERMUX_PKG_HOMEPAGE=https://www.perl.org/
TERMUX_PKG_DESCRIPTION="Capable, feature-rich programming language"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Packages which should be rebuilt after version change:
# - exiftool
# - irssi
# - libapt-pkg-perl
# - libregexp-assemble-perl
# - psutils
# - subversion
TERMUX_PKG_VERSION=(5.36.0
                    1.4)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=(e26085af8ac396f62add8a533c3a0ea8c8497d836f0689347ac5abd7b7a4e00a
                   be9d9f9f7148edff7a2f9695ba3cb7e3975eff6b25a9a81dd311725fd757aa91)
TERMUX_PKG_SRCURL=(http://www.cpan.org/src/5.0/perl-${TERMUX_PKG_VERSION}.tar.gz
		   https://github.com/arsv/perl-cross/releases/download/${TERMUX_PKG_VERSION[1]}/perl-cross-${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_RM_AFTER_INSTALL="bin/perl${TERMUX_PKG_VERSION}"

termux_step_post_get_source() {
	# This port uses perl-cross: http://arsv.github.io/perl-cross/
	cp -rf perl-cross-${TERMUX_PKG_VERSION[1]}/* .
}

termux_step_configure() {
	export PATH=$PATH:$TERMUX_STANDALONE_TOOLCHAIN/bin

	(
		ORIG_AR=$AR; unset AR
		ORIG_AS=$AS; unset AS
		ORIG_CC=$CC; unset CC
		ORIG_CXX=$CXX; unset CXX
		ORIG_CFLAGS=$CFLAGS; unset CFLAGS
		ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
		ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
		ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
		ORIG_RANLIB=$RANLIB; unset RANLIB
		ORIG_LD=$LD; unset LD

		cd $TERMUX_PKG_BUILDDIR
		$TERMUX_PKG_SRCDIR/configure \
			--target=$TERMUX_HOST_PLATFORM \
			--with-cc="$ORIG_CC" \
			--with-ranlib="$ORIG_RANLIB" \
			-Dosname=android \
			-Dsysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot \
			-Dprefix=$TERMUX_PREFIX \
			-Dsh=$TERMUX_PREFIX/bin/sh \
			-Dld="$ORIG_CC -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags" \
			-Dar="$ORIG_AR" \
			-Duseshrplib \
			-Duseithreads \
			-Dusemultiplicity
	)
}

termux_step_post_make_install() {
	# Replace hardlinks with symlinks:
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1
	rm perlbug.1
	ln -s perlthanks.1 perlbug.1

	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	ln -f -s perl5/${TERMUX_PKG_VERSION}/${TERMUX_ARCH}-android/CORE/libperl.so libperl.so

	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include
	ln -f -s ../lib/perl5/${TERMUX_PKG_VERSION}/${TERMUX_ARCH}-android/CORE perl
	cd ../lib/perl5/${TERMUX_PKG_VERSION}/${TERMUX_ARCH}-android/
	chmod +w Config_heavy.pl
	sed 's',"--sysroot=$TERMUX_STANDALONE_TOOLCHAIN"/sysroot,"-I${TERMUX_PREFIX}/include",'g' Config_heavy.pl > Config_heavy.pl.new
	sed 's',"$TERMUX_STANDALONE_TOOLCHAIN"/sysroot,"-I${TERMUX_PREFIX%%/usr}",'g' Config_heavy.pl.new > Config_heavy.pl
	rm Config_heavy.pl.new
}
