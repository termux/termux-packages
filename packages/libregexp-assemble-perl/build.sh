TERMUX_PKG_HOMEPAGE=https://metacpan.org/pod/Regexp::Assemble
TERMUX_PKG_DESCRIPTION="Perl module to merge several regular expressions"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.38
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://salsa.debian.org/perl-team/modules/packages/libregexp-assemble-perl/-/archive/upstream/${TERMUX_PKG_VERSION}/libregexp-assemble-perl-upstream-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ca31b4111b825a4aa5262b07412822457910577881c2edb19407baad3997ebb0
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true


termux_step_configure() {
	perl Makefile.PL
}

termux_step_make_install() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man3/
	cp $TERMUX_PKG_SRCDIR/blib/man3/Regexp::Assemble.3pm \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man3/

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/Regexp/
	cp $TERMUX_PKG_SRCDIR/lib/Regexp/Assemble.pm \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/Regexp/
}
