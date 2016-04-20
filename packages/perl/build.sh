# This port uses perl-cross: http://arsv.github.io/perl-cross/index.html
TERMUX_PKG_HOMEPAGE=http://www.perl.org/
TERMUX_PKG_DESCRIPTION="Capable, feature-rich programming language"
# cpan modules will require make:
TERMUX_PKG_DEPENDS="make"
TERMUX_PKG_VERSION=5.22.1
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=http://www.cpan.org/src/5.0/perl-${TERMUX_PKG_VERSION}.tar.gz
# Does not work with parallell builds:
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_RM_AFTER_INSTALL="bin/perl${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_post_extract_package () {
	PERLCROSS_VERSION=1.0.2
	PERLCROSS_FILE=perl-${TERMUX_PKG_VERSION}-cross-${PERLCROSS_VERSION}.tar.gz
	PERLCROSS_TAR=$TERMUX_PKG_CACHEDIR/$PERLCROSS_FILE
	test ! -f $PERLCROSS_TAR && curl -o $PERLCROSS_TAR -L https://github.com/arsv/perl-cross/releases/download/$PERLCROSS_VERSION/$PERLCROSS_FILE
	cd $TERMUX_PKG_SRCDIR
	tar xf $PERLCROSS_TAR
	cd perl-${TERMUX_PKG_VERSION}
	cp -Rf * ../

	# Remove old installation to force fresh:
	rm -rf $TERMUX_PREFIX/lib/perl5
}

termux_step_configure () {
        export PATH=$PATH:$TERMUX_STANDALONE_TOOLCHAIN/bin

	ORIG_AR=$AR; unset AR
	ORIG_AS=$AS; unset AS
	ORIG_CC=$CC; unset CC
	ORIG_CXX=$CXX; unset CXX
	ORIG_CPP=$CPP; unset CPP
	ORIG_CFLAGS=$CFLAGS; unset CFLAGS
	ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
	ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
	ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
	ORIG_RANLIB=$RANLIB; unset RANLIB
	ORIG_LD=$LD; unset LD

	# Since we specify $TERMUX_PREFIX/bin/sh below for the shell
	# it will be run during the build, so temporarily (removed in
	# termux_step_post_make_install below) setup symlink:
	rm -f $TERMUX_PREFIX/bin/sh
	ln -s /bin/sh $TERMUX_PREFIX/bin/sh

	cd $TERMUX_PKG_BUILDDIR
	$TERMUX_PKG_SRCDIR/configure \
		--target=$TERMUX_HOST_PLATFORM \
		-Dsysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot \
		-Dprefix=$TERMUX_PREFIX \
		-Dsh=$TERMUX_PREFIX/bin/sh \
		-A ccflags="-specs=$TERMUX_SCRIPTDIR/termux.spec" \
		-A ldflags="-specs=$TERMUX_SCRIPTDIR/termux.spec"
}

termux_step_post_make_install () {
	# Replace hardlinks with symlinks:
	cd $TERMUX_PREFIX/share/man/man1
	rm {perlbug.1,c2ph.1}
	ln -s perlthanks.1 perlbug.1
	ln -s pstruct.1 c2ph.1

	# Fix reference to termux.spec used only when cross compiling:
	perl -p -i -e 's@-specs=/home/fornwall/dc/termux.spec@@g' $TERMUX_PREFIX/lib/perl5/*/*-linux/Config_heavy.pl

	# lib/perl5/5.22.0/arm-linux/Config_heavy.pl
	# Cleanup:
	rm $TERMUX_PREFIX/bin/sh
}
