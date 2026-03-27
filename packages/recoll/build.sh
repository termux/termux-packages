TERMUX_PKG_HOMEPAGE=https://www.recoll.org/
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.43.14"
TERMUX_PKG_SRCURL="https://www.recoll.org/recoll-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=391e5c6edb78c6cd487d94c5abe44fe0c64f99f0acdab287d5821fd4e806f89b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="aspell, file, jsoncpp,  libc++, libiconv, libxapian, libxml2, libxslt, zlib"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
# -Dext4-birthtime=false disables the use of the statx syscall
# it is also set to false by default at time of writing,
# but set it explicitly because Termux previously
# had a patch forcibly disabling the use of the statx syscall in recoll
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpython-chm=false
-Dpython-aspell=false
-Daspell=true
-Dx11mon=false
-Dqtgui=false
-Dsystemd=false
-Dext4-birthtime=false
"

termux_step_pre_configure() {
	termux_setup_python_pip
	rm -f CMakeLists.txt

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}/"
}
