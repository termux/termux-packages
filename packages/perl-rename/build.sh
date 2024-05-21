TERMUX_PKG_HOMEPAGE=https://search.cpan.org/~pederst/rename/
TERMUX_PKG_DESCRIPTION="renames multiple files using perl expressions."
TERMUX_PKG_LICENSE="Artistic-License-2.0, GPL-2.0" # https://metacpan.org/pod/Software::License::Perl_5
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14
TERMUX_PKG_SRCURL=https://cpan.metacpan.org/authors/id/P/PE/PEDERST/rename-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4d19e5cb8fb09fe35e6df69ae07132cf621b0b2a82f54149091bce630642adbd
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PREFIX=$TERMUX_PREFIX
INSTALLSITEMAN1DIR=$TERMUX_PREFIX/share/man/man1
INSTALLSITEMAN3DIR=$TERMUX_PREFIX/share/man/man3
"

termux_step_configure() {
	perl Makefile.PL $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_massage() {
	find $TERMUX_PKG_MASSAGEDIR -type f -name "rename*" -execdir sh -c 'mv {} $(echo {} | sed "s|rename|perl-rename|")' \;
	rm -rf $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/x86_64-linux-gnu
}
