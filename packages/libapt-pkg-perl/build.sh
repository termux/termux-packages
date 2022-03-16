TERMUX_PKG_HOMEPAGE=https://packages.debian.org/libapt-pkg-perl
TERMUX_PKG_DESCRIPTION="Perl interface to APT's libapt-pkg"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.40
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/liba/libapt-pkg-perl/libapt-pkg-perl_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=524d2ef77f3d6896c50e7674022d85e4a391a6a2b3c65ba5e50ac671fa7ce4a1
TERMUX_PKG_DEPENDS="apt, perl"
TERMUX_PKG_BUILD_IN_SRC=true


termux_step_make() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	CFLAGS+=" -I$TERMUX_PREFIX/lib/perl5/$perl_version/${TERMUX_ARCH}-android/CORE \
		-I$TERMUX_PREFIX/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
	LDFLAGS+=" -L$TERMUX_PREFIX/lib/perl5/$perl_version/${TERMUX_ARCH}-android/CORE \
		-L$TERMUX_PREFIX/lib -lperl"
	perl Makefile.PL INSTALLDIRS=perl DESTDIR="$TERMUX_PKG_MASSAGEDIR" \
		INSTALLMAN3DIR="$TERMUX_PREFIX/share/man/man3" \
		LIB=$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android
	make CC="${CC}++" LD="${CC}++" OTHERLDFLAGS="$LDFLAGS" CCFLAGS="$CFLAGS"
}

termux_step_post_massage() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	mv $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/x86_64-linux-gnu-thread-multi/* \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/
	rmdir $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/x86_64-linux-gnu-thread-multi
}
