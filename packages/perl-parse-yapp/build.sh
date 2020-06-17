TERMUX_PKG_HOMEPAGE=https://search.cpan.org/dist/Parse-Yapp
TERMUX_PKG_DESCRIPTION="Generates OO LALR parser modules"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_VERSION=1.21
TERMUX_PKG_SRCURL=https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	local current_perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	PERL_MM_USE_DEFAULT=1 perl Makefile.PL \
				INSTALLDIRS=site \
				INSTALLSITELIB="$TERMUX_PREFIX/lib/perl${current_perl_version:0:1}/site_perl/$current_perl_version" \
				INSTALLSITEBIN="$TERMUX_PREFIX/bin" \
				INSTALLSITESCRIPT="$TERMUX_PREFIX/bin" \
				INSTALLSITEMAN1DIR="$TERMUX_PREFIX/share/man/man1" \
				INSTALLSITEMAN3DIR="$TERMUX_PREFIX/share/man/man3" \
				NO_PACKLIST=1 \
				NO_PERLLOCAL=1
}

termux_step_install_license() {
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/gpl-1.0.txt" "$TERMUX_PREFIX/share/doc/perl-parse-yapp/LICENSE"
}
