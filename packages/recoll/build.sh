TERMUX_PKG_HOMEPAGE=https://www.recoll.org/
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.40.3"
TERMUX_PKG_SRCURL=https://www.recoll.org/recoll-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cb7d9ed9b95bc4527dc2ff67b3521970e65e4200cc0007139e26e107817703b4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="aspell, file, libc++, libiconv, libxapian, libxml2, libxslt, zlib"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpython-chm=false
-Dpython-aspell=false
-Daspell=true
-Dx11mon=false
-Dqtgui=false
-Dsystemd=false
"

termux_step_pre_configure() {
	rm -f CMakeLists.txt

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}/"
}
