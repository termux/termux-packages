TERMUX_PKG_HOMEPAGE=http://www.pcre.org/
TERMUX_PKG_DESCRIPTION="Library implementing regular expression pattern matching using the same syntax and semantics as Perl 5"
TERMUX_PKG_VERSION=8.40
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=00e27a29ead4267e3de8111fcaa59b132d0533cdfdbdddf4b0604279acbcf4f4
TERMUX_PKG_RM_AFTER_INSTALL="bin/pcre-config bin/pcregrep bin/pcretest share/man/man1/pcre*.1 lib/libpcreposix.so lib/libpcreposix.so.0 lib/libpcreposix.so.0.0.2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-cpp --enable-jit --enable-utf8 --enable-unicode-properties"
