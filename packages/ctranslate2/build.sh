TERMUX_PKG_HOMEPAGE=https://github.com/OpenNMT/CTranslate2
TERMUX_PKG_DESCRIPTION="Fast inference engine for Transformer models"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="4.7.1"
TERMUX_PKG_SRCURL=https://github.com/OpenNMT/CTranslate2/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=64beb499c1e33500a691dfbe10cc5def7b914413c7f7c2830b0e0d8d544a9f7e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, libopenblas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS=ON
-DWITH_CUDA=OFF
-DWITH_CUDNN=OFF
-DWITH_MKL=OFF
-DWITH_OPENBLAS=ON
-DOPENMP_RUNTIME=COMP
-DWITH_ACCELERATE=OFF
-DWITH_DNNL=OFF
-DWITH_RUY=OFF
-DBUILD_CLI=ON
-DBUILD_TESTS=OFF
-DENABLE_CPU_DISPATCH=OFF
"

termux_step_post_get_source() {
	# Initialize git submodules manually by downloading them
	echo "Downloading third-party dependencies..."    
    # spdlog - logging library
    local SPDLOG_VERSION="1.14.1"
    if [ ! -d "third_party/spdlog/include" ]; then
        echo "Downloading spdlog ${SPDLOG_VERSION}..."
        mkdir -p third_party/spdlog
        pushd third_party/spdlog > /dev/null
        wget -q -O spdlog.tar.gz "https://github.com/gabime/spdlog/archive/refs/tags/v${SPDLOG_VERSION}.tar.gz"
        tar -xzf spdlog.tar.gz --strip-components=1
        rm spdlog.tar.gz
        popd > /dev/null
    fi
    
    # cpu_features - CPU feature detection
    local CPU_FEATURES_VERSION="0.9.0"
    if [ ! -d "third_party/cpu_features/include" ]; then
        echo "Downloading cpu_features ${CPU_FEATURES_VERSION}..."
        mkdir -p third_party/cpu_features
        pushd third_party/cpu_features > /dev/null
        wget -q -O cpu_features.tar.gz "https://github.com/google/cpu_features/archive/refs/tags/v${CPU_FEATURES_VERSION}.tar.gz"
        tar -xzf cpu_features.tar.gz --strip-components=1
        rm cpu_features.tar.gz
        popd > /dev/null
    fi
    
    # cxxopts - command line parsing
    local CXXOPTS_VERSION="3.2.1"
    if [ ! -d "third_party/cxxopts/include" ]; then
        echo "Downloading cxxopts ${CXXOPTS_VERSION}..."
        mkdir -p third_party/cxxopts
        pushd third_party/cxxopts > /dev/null
        wget -q -O cxxopts.tar.gz "https://github.com/jarro2783/cxxopts/archive/refs/tags/v${CXXOPTS_VERSION}.tar.gz"
        tar -xzf cxxopts.tar.gz --strip-components=1
        rm cxxopts.tar.gz
        popd > /dev/null
    fi
    
    echo "Third-party dependencies downloaded successfully."
}

termux_step_pre_configure() {
    # CTranslate2 requires C++17
    CXXFLAGS+=" -std=c++17"
    
    # Use static OpenMP linking to avoid libomp.so dependency
    # The -static-openmp flag forces static linking with the OpenMP runtime
    LDFLAGS+=" -fopenmp -static-openmp"
    CXXFLAGS+=" -fopenmp -static-openmp"
    
    # Set OpenBLAS library path
    if [ -f "${TERMUX_PREFIX}/lib/libopenblas.so" ]; then
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DBLA_VENDOR=OpenBLAS"
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DOPENBLAS_INCLUDE_DIR=${TERMUX_PREFIX}/include/openblas"
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DOPENBLAS_LIBRARY=${TERMUX_PREFIX}/lib/libopenblas.so"
    fi
}
