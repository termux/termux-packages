TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gengetopt/
TERMUX_PKG_DESCRIPTION="gengetopt is a tool to write command line option parsing code for C programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.23.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gengetopt/gengetopt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3b9def48422bd45f78af95936200b7f9287369a3db76c4907c42fe10f4922ab6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	# gengetopt (2.23 at time of writing) uses std::unary_function, removed in C++ 17:
	CXXFLAGS+=" -std=c++11"
}
