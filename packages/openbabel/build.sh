TERMUX_PKG_HOMEPAGE=http://openbabel.org/wiki/Main_Page
TERMUX_PKG_DESCRIPTION="Open Babel is a chemical toolbox designed to speak the many languages of chemical data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/openbabel/openbabel/archive/refs/tags/openbabel-${TERMUX_PKG_VERSION//./-}.tar.gz"
TERMUX_PKG_SHA256=9aadf9f01b3d0ff15d49fcd28d7d76b923218d70bf10f99ea4cc466607f4c7e2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcairo, libxml2, rapidjson, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, eigen"
TERMUX_PKG_BREAKS="openbabel-dev"
TERMUX_PKG_REPLACES="openbabel-dev"
TERMUX_PKG_GROUPS="science"
# MAEPARSER gives an error related to boost's unit_test_framework during configure

# -DBUILD_SHARED=OFF fixes the loading of plugins by disabling dynamic loading of plugins
# and enabling static plugins and static libopenbabel.
# https://github.com/termux/termux-packages/issues/17414
# https://github.com/termux/termux-packages/issues/17628

# the WITH_STATIC_LIBXML setting is very misleading.
# its true meaning is much closer to "static libopenbabel with shared or static libxml2",
# rather than "static or shared libopenbabel with static libxml2"
# in this case, it ends up being "static libopenbabel with shared libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_MAEPARSER=OFF
-DWITH_COORDGEN=OFF
-DENABLE_TESTS=OFF
-DBUILD_SHARED=OFF
-DWITH_STATIC_LIBXML=ON
"

termux_step_pre_configure() {
	export LDFLAGS+=" -lxml2"
}
