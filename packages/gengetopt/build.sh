TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gengetopt/
TERMUX_PKG_DESCRIPTION="gengetopt is a tool to write command line option parsing code for C programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.23
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/gengetopt/gengetopt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b941aec9011864978dd7fdeb052b1943535824169d2aa2b0e7eae9ab807584ac
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	# gengetopt (2.23 at time of writing) uses std::unary_function, removed in C++ 17:
	CXXFLAGS+=" -std=c++11"
}
