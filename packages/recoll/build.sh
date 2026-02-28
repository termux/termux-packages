TERMUX_PKG_HOMEPAGE=https://www.recoll.org/
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.43.13"
TERMUX_PKG_SRCURL="https://www.recoll.org/recoll-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=140bf1e4fc51299f60dad580dffd64733e1d06fb14c6f752e2a34d4d70540c19
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
	rm -f CMakeLists.txt

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}/"
}
