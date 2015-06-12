# This port uses perl-cross: http://arsv.github.io/perl-cross/index.html
TERMUX_PKG_HOMEPAGE=http://www.perl.org/
TERMUX_PKG_DESCRIPTION="Capable, feature-rich programming language"
TERMUX_PKG_VERSION=5.20.2
TERMUX_PKG_SRCURL=http://www.cpan.org/src/5.0/perl-${TERMUX_PKG_VERSION}.tar.gz
# Does not work with parallell builds:
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_RM_AFTER_INSTALL="bin/perl${TERMUX_PKG_VERSION}"

termux_step_post_extract_package () {
	PERLCROSS_VERSION=0.9.6
	PERLCROSS_FILE=perl-${TERMUX_PKG_VERSION}-cross-${PERLCROSS_VERSION}.tar.gz
	PERLCROSS_TAR=$TERMUX_PKG_CACHEDIR/$PERLCROSS_FILE
	test ! -f $PERLCROSS_TAR && curl -L https://raw.github.com/arsv/perl-cross/releases/$PERLCROSS_FILE > $PERLCROSS_TAR
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

	cd $TERMUX_PKG_BUILDDIR
	$TERMUX_PKG_SRCDIR/configure \
		--target=$TERMUX_HOST_PLATFORM \
		-Dsysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot \
		-Dprefix=$TERMUX_PREFIX \
		-Dsh=/system/bin/sh \
		-A ccflags="-specs=$TERMUX_SCRIPTDIR/termux.spec" \
		-A ldflags="-specs=$TERMUX_SCRIPTDIR/termux.spec"
}
