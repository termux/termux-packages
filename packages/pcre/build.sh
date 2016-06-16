TERMUX_PKG_HOMEPAGE=http://www.pcre.org/
TERMUX_PKG_DESCRIPTION="Library implementing regular expression pattern matching using the same syntax and semantics as Perl 5"
TERMUX_PKG_VERSION=8.39
TERMUX_PKG_SRCURL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcre-config bin/pcregrep bin/pcretest share/man/man1/pcre*.1 lib/libpcreposix.so lib/libpcreposix.so.0 lib/libpcreposix.so.0.0.2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-cpp --enable-utf8 --enable-unicode-properties"


