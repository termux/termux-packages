TERMUX_PKG_HOMEPAGE=https://www.pcre.org
TERMUX_PKG_DESCRIPTION="Perl 5 compatible regular expression library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.39
TERMUX_PLG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${TERMUX_PKG_VERSION}/pcre2-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0f03caf57f81d9ff362ac28cd389c055ec2bf0678d277349a1a4bee00ad6d440
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+"
TERMUX_PKG_BREAKS="pcre2-dev"
TERMUX_PKG_REPLACES="pcre2-dev"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/pcre2grep
bin/pcre2test
share/man/man1/pcre2*.1
lib/libpcre2-posix.so
lib/pkgconfig/libpcre2-posix.pc
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-jit
--enable-pcre2-16
--enable-pcre2-32
"
