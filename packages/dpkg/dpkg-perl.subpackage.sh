TERMUX_SUBPKG_DESCRIPTION="Perl modules for dpkg"
TERMUX_SUBPKG_INCLUDE="share/perl5"
TERMUX_SUBPKG_DEPENDS="perl, clang, make"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true

termux_step_create_subpkg_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	export PERL_MM_USE_DEFAULT=1

	echo "Sideloading Perl Locale::gettext ..."
	cpan -Ti Locale::gettext

	exit 0
	POSTINST_EOF
}
