TERMUX_PKG_HOMEPAGE=https://github.com/google/oboe
TERMUX_PKG_DESCRIPTION="Google Oboe - C++ library for high-performance audio on Android"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL="https://github.com/google/oboe/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0ccf2110640a2b4489f1c93a404f2978656b434d8c5dc9cb6258f9cc95c79b15
# Oboe uses an unversioned SONAME; updates require ABI review and
# coordinated reverse-dependency rebuilds.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-stub, libc++"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DOBOE_DO_NOT_DEFINE_OPENSL_ES_CONSTANTS=ON
"

termux_step_post_make_install() {
	# Generate pkg-config file. Upstream Oboe ships no .pc or .pc.in
	# template, so it must be written by hand.
	mkdir -p "$TERMUX_PREFIX/lib/pkgconfig"
	cat <<EOF > "$TERMUX_PREFIX/lib/pkgconfig/oboe.pc"
prefix=$TERMUX_PREFIX
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: oboe
Description: $TERMUX_PKG_DESCRIPTION
Version: $TERMUX_PKG_VERSION
Libs: -L\${libdir} -loboe
Cflags: -I\${includedir}
EOF

	# The source build installs no CMake package config. Provide the
	# prefab oboe::oboe target with Termux installation paths.
	local _cmakedir="$TERMUX_PREFIX/lib/cmake/oboe"
	mkdir -p "$_cmakedir"
	cat <<EOF > "$_cmakedir/oboeConfig.cmake"
if(NOT TARGET oboe::oboe)
add_library(oboe::oboe SHARED IMPORTED)
set_target_properties(oboe::oboe PROPERTIES
    IMPORTED_LOCATION "$TERMUX_PREFIX/lib/liboboe.so"
    INTERFACE_INCLUDE_DIRECTORIES "$TERMUX_PREFIX/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()
EOF

	cat <<EOF > "$_cmakedir/oboeConfigVersion.cmake"
set(PACKAGE_VERSION "$TERMUX_PKG_VERSION")
if("\${PACKAGE_VERSION}" VERSION_LESS "\${PACKAGE_FIND_VERSION}")
    set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
    set(PACKAGE_VERSION_COMPATIBLE TRUE)
    if("\${PACKAGE_VERSION}" VERSION_EQUAL "\${PACKAGE_FIND_VERSION}")
        set(PACKAGE_VERSION_EXACT TRUE)
    endif()
endif()
EOF
}
