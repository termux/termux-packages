TERMUX_PKG_HOMEPAGE=https://search.cpan.org/~pederst/rename/
TERMUX_PKG_DESCRIPTION="renames multiple files using perl expressions."
TERMUX_PKG_LICENSE="Artistic-License-2.0, GPL-2.0" # https://metacpan.org/pod/Software::License::Perl_5
TERMUX_PKG_MAINTAINER="@ELWAER-M"
TERMUX_PKG_VERSION=1.11
TERMUX_PKG_SRCURL=https://cpan.metacpan.org/authors/id/P/PE/PEDERST/rename-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f03f33d3a17d3a3599c83f514f0694fd833b606920132925e3fdbd8a1a3e44b
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	perl Makefile.PL PREFIX=$TERMUX_PREFIX
}

termux_step_post_massage() {
	find $TERMUX_PKG_MASSAGEDIR -type f -name "rename*" -execdir sh -c 'mv {} $(echo {} | sed "s|rename|perl-rename|")' \;
	rm -rf $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/x86_64-linux-gnu
}
