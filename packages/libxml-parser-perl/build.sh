TERMUX_PKG_HOMEPAGE=http://www.libexpat.org/
TERMUX_PKG_DESCRIPTION="Perl module for parsing XML file"
TERMUX_PKG_VERSION=2.44
TERMUX_PKG_SRCURL=http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="perl, libexpat"
termux_step_post_extract_package() {
 $TERMUX_PREFIX/bin/perl Makefile.PL EXPATLIBPATH=$TERMUX_PREFIX/lib EXPATINCPATH=$TERMUX_PREFIX/include
 }
