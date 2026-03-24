TERMUX_PKG_HOMEPAGE=https://github.com/google/bloaty
TERMUX_PKG_DESCRIPTION="A size profiler for binaries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_DEPENDS="abseil-cpp, capstone, libprotobuf, zlib"
TERMUX_PKG_BUILD_DEPENDS="git, cmake, ninja"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBLOATY_ENABLE_RE2=OFF
-DBLOATY_PREFER_SYSTEM_ABSL=OFF
-DBLOATY_PREFER_SYSTEM_CAPSTONE=ON
-DBLOATY_PREFER_SYSTEM_PROTOBUF=ON
-DBLOATY_PREFER_SYSTEM_ZLIB=ON
-DBLOATY_PREFER_SYSTEM_ZSTD=ON


"
termux_step_get_source() {
    # Clone without submodules
    git clone --depth 1 -b v${TERMUX_PKG_VERSION} https://github.com/google/bloaty $TERMUX_PKG_SRCDIR
    cd $TERMUX_PKG_SRCDIR
    ls -al
}

termux_step_pre_configure() {
	termux_setup_protobuf
	# Fix Capstone detection
sed -i '/if(BLOATY_PREFER_SYSTEM_CAPSTONE)/,/^endif()/{
/pkg_search_module(CAPSTONE capstone)/a\
  if(NOT CAPSTONE_FOUND)\
    find_path(CAPSTONE_INCLUDE_DIRS NAMES capstone/capstone.h)\
    find_library(CAPSTONE_LIBRARIES NAMES capstone)\
    if(CAPSTONE_INCLUDE_DIRS AND CAPSTONE_LIBRARIES)\
      set(CAPSTONE_FOUND TRUE)\
    endif()\
  endif()
}' CMakeLists.txt

# Fix Protobuf detection  
sed -i '/if(BLOATY_PREFER_SYSTEM_PROTOBUF)/,/^endif()/{
/pkg_search_module(PROTOBUF protobuf)/a\
  if(NOT PROTOBUF_FOUND)\
    find_package(Protobuf QUIET)\
    if(Protobuf_FOUND)\
      set(PROTOBUF_FOUND TRUE)\
      set(PROTOBUF_INCLUDE_DIRS ${Protobuf_INCLUDE_DIRS})\
      set(PROTOBUF_LIBRARIES ${Protobuf_LIBRARIES})\
    endif()\
  endif()
}' CMakeLists.txt
    # Force CMake to find libraries
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
    -DCAPSTONE_FOUND=TRUE
    -DCAPSTONE_INCLUDE_DIRS=${TERMUX_PREFIX}/include
    -DCAPSTONE_LIBRARIES=${TERMUX_PREFIX}/lib/libcapstone.so
    -DPROTOBUF_FOUND=TRUE
    -DPROTOBUF_INCLUDE_DIRS=${TERMUX_PREFIX}/include
    -DPROTOBUF_LIBRARIES=${TERMUX_PREFIX}/lib/libprotobuf.so
    "
    

    export CXXFLAGS="${CXXFLAGS}  -I$TERMUX_PKG_SRCDIR/third_party"
    export LDFLAGS="${LDFLAGS} -L${TERMUX_PREFIX}/lib"

}
