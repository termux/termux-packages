TERMUX_PKG_HOMEPAGE="https://nekovm.org/"
TERMUX_PKG_DESCRIPTION="The Neko Virtual Machine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/HaxeFoundation/neko/archive/refs/tags/v${TERMUX_PKG_VERSION//[.]/-}.tar.gz
TERMUX_PKG_SHA256=850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995
TERMUX_PKG_DEPENDS="libgc,openssl,zlib,apache2,libsqlite,mbedtls"
TERMUX_PKG_SRCDIR="../src"


termux_step_configure_cmake() {
        termux_setup_cmake

        local BUILD_TYPE=Release
        [ "$TERMUX_DEBUG" = "true" ] && BUILD_TYPE=Debug

        local CMAKE_PROC=$TERMUX_ARCH
        test $CMAKE_PROC == "arm" && CMAKE_PROC='armv7-a'
        local MAKE_PROGRAM_PATH
        if [ "$TERMUX_CMAKE_BUILD" = Ninja ]; then
                termux_setup_ninja
                MAKE_PROGRAM_PATH=$(command -v ninja)
        else
                MAKE_PROGRAM_PATH=$(command -v make)
        fi

        local CMAKE_ADDITIONAL_ARGS=()
        if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
                CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
                CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
                LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"

                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_CROSSCOMPILING=True")
                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_LINKER=$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD $LDFLAGS")
                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_SYSTEM_NAME=Android")

                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL")
                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_SYSTEM_PROCESSOR=$CMAKE_PROC")
                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN")
        else
                CMAKE_ADDITIONAL_ARGS+=("-DCMAKE_LINKER=$(command -v $LD) $LDFLAGS")
        fi
        cmake -G "$TERMUX_CMAKE_BUILD" -S ../src \
                -DCMAKE_AR="$(command -v $AR)" \
                -DCMAKE_UNAME="$(command -v uname)" \
                -DCMAKE_RANLIB="$(command -v $RANLIB)" \
                -DCMAKE_STRIP="$(command -v $STRIP)" \
                -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                -DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
                -DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
                -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
                -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
                -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
                -DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
                -DCMAKE_MAKE_PROGRAM=$MAKE_PROGRAM_PATH \
                -DCMAKE_SKIP_INSTALL_RPATH=ON \
                -DCMAKE_USE_SYSTEM_LIBRARIES=True \
                "${CMAKE_ADDITIONAL_ARGS[@]}" \
                -Wno-dev \
                -DWITH_UI=n \
                -DWITH_MYSQL=n \
                -DWITH_REGEXP=n \
                $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
