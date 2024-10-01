TERMUX_PKG_HOMEPAGE=https://opencolorio.org
TERMUX_PKG_DESCRIPTION="A color management framework for visual effects and animation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.0"
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00fc49578abf8435eb041088af44c8c4bcaafbe04021d53d341adcd488aec711
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="imath, libc++, libexpat, libminizip-ng, libyaml-cpp, pystring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpystring_INCLUDE_DIR=$TERMUX_PREFIX/lib
-DOCIO_BUILD_PYTHON=OFF
"
# Command-line apps depend on packages in x11 repo (for OpenGL functionality):
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DOCIO_BUILD_APPS=OFF"

termux_step_pre_configure() {
	# error: constant expression evaluates to -1 which cannot be narrowed to type 'char' [-Wc++11-narrowing]
	# also same is used while building apt
	CXXFLAGS+=" -Wno-c++11-narrowing"
	CXXFLAGS+=" -I$PREFIX/include/pystring"
}
