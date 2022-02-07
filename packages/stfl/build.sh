TERMUX_PKG_HOMEPAGE=http://www.clifford.at/stfl
TERMUX_PKG_DESCRIPTION="Structured Terminal Forms Language/Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://grimler.se/termux/stfl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses"
TERMUX_PKG_BREAKS="stfl-dev"
TERMUX_PKG_REPLACES="stfl-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	# mkmf.rb can't find header files for ruby at /usr/lib/ruby/include/ruby.h
	sed -i 's/FOUND_RUBY = 1/FOUND_RUBY = 0/g' Makefile.cfg
	
	# /usr/bin/ld: ../libstfl.a(public.o): Relocations in generic ELF (EM: 183)
	# /usr/bin/ld: ../libstfl.a: error adding symbols: file in wrong format
	sed -i 's/FOUND_PERL5 = 1/FOUND_PERL5 = 0/g' Makefile.cfg
}

termux_step_configure() {
	CC+=" $CPPFLAGS"
	export LDLIBS="-liconv"
}
