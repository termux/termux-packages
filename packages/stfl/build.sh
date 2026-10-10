TERMUX_PKG_HOMEPAGE=http://www.clifford.at/stfl
TERMUX_PKG_DESCRIPTION="Structured Terminal Forms Language/Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_REVISION=8
# Using newsboat patched fork:
# https://github.com/newsboat/stfl
# Awaiting newsboat switching away from stfl, after which this package can be dropped:
# https://github.com/newsboat/newsboat/issues/232
TERMUX_PKG_SRCURL=https://github.com/newsboat/stfl/archive/bbb2404580e845df2556560112c8aefa27494d66.zip
TERMUX_PKG_SHA256=96c24d97fb07eb57b54fed0e2d1716c4420e9c6544b9d77b8da1d65e70f17398
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BREAKS="stfl-dev"
TERMUX_PKG_REPLACES="stfl-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	# mkmf.rb can't find header files for ruby at /usr/lib/ruby/include/ruby.h
	sed -i 's/FOUND_RUBY = 1/FOUND_RUBY = 0/g' Makefile.cfg

	# /usr/bin/ld: ../libstfl.a(public.o): Relocations in generic ELF (EM: 183)
	# /usr/bin/ld: ../libstfl.a: error adding symbols: file in wrong format
	sed -i 's/FOUND_PERL5 = 1/FOUND_PERL5 = 0/g' Makefile.cfg

	CPPFLAGS+=" -DNCURSES_WIDECHAR"
}

termux_step_configure() {
	CC+=" $CPPFLAGS"
	export LDLIBS="-liconv"
}
