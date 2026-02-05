TERMUX_PKG_HOMEPAGE=https://github.com/ggml-org/whisper.cpp
TERMUX_PKG_DESCRIPTION="Port of OpenAI's Whisper model in C/C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
# Remove 'v' prefix - Debian package versions must start with a digit
TERMUX_PKG_VERSION="1.8.3"
# Use the version WITH 'v' prefix for the GitHub tag
TERMUX_PKG_SRCURL=https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=870ba21409cdf66697dc4db15ebdb13bc67037d76c7cc63756c81471d8f1731a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libcurl, sdl2, ffmpeg"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, opencl-headers, ocl-icd, shaderc, libopenblas, glslang"
TERMUX_PKG_CONFLICTS="llama-cpp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWHISPER_BUILD_TESTS=OFF
-DWHISPER_BUILD_SERVER=OFF
-DWHISPER_BUILD_EXAMPLES=ON
-DWHISPER_CURL=ON
-DWHISPER_SDL2=ON
-DWHISPER_FFMPEG=ON
-DWHISPER_SANITIZE_THREAD=OFF
-DWHISPER_SANITIZE_ADDRESS=OFF
-DGGML_BACKEND_DL=ON
-DGGML_OPENMP=OFF
-DGGML_BLAS=1
-DGGML_VULKAN=ON
-DGGML_VULKAN_SHADERS_GEN_TOOLCHAIN=$TERMUX_PKG_BUILDER_DIR/host-toolchain.cmake
-DGGML_OPENCL=ON
"

TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
    export PATH="$NDK/shader-tools/linux-x86_64:$PATH"
    LDFLAGS+=" -landroid-spawn"
    
    # Add -MD flag to glslc for dependency generation
    export GGML_GLSLC_ARGS="-MD"

    local _libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}/libvulkan.so"   
    #local _libvulkan="${TERMUX_PREFIX}/libvulkan.so"
    if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" && "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
        _libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/28/libvulkan.so"
    fi
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARY=${_libvulkan}"
    
        # Force SDL2 detection
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSDL2_INCLUDE_DIR=${TERMUX_PREFIX}/include/SDL2"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSDL2_LIBRARY=${TERMUX_PREFIX}/lib/libSDL2.so"
    
    # Force FFmpeg detection - set paths for all ffmpeg components
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVCODEC_INCLUDE_DIR=${TERMUX_PREFIX}/include"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVCODEC_LIBRARY=${TERMUX_PREFIX}/lib/libavcodec.so"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVFORMAT_INCLUDE_DIR=${TERMUX_PREFIX}/include"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVFORMAT_LIBRARY=${TERMUX_PREFIX}/lib/libavformat.so"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVUTIL_INCLUDE_DIR=${TERMUX_PREFIX}/include"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVUTIL_LIBRARY=${TERMUX_PREFIX}/lib/libavutil.so"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSWRESAMPLE_INCLUDE_DIR=${TERMUX_PREFIX}/include"
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSWRESAMPLE_LIBRARY=${TERMUX_PREFIX}/lib/libswresample.so"
    
    # Force link flags
    LDFLAGS+=" -lSDL2 -lavcodec -lavformat -lavutil -lswresample"
}

termux_step_post_make_install() {
    echo "=== whisper-cpp: Installing additional scripts ==="
    
    # Install model download scripts if they exist
    echo "Checking for model download scripts in ${TERMUX_PKG_SRCDIR}/models/"
    if [ -f "${TERMUX_PKG_SRCDIR}/models/download-ggml-model.sh" ]; then
        echo "  Installing: download-ggml-model.sh -> whisper-download-model"
        install -Dm755 "${TERMUX_PKG_SRCDIR}/models/download-ggml-model.sh" \
            "${TERMUX_PREFIX}/bin/whisper-download-model"
    else
        echo "  Not found: download-ggml-model.sh"
    fi
    
    # Install any other scripts from models/ directory
    echo "Checking for other scripts in models/ directory..."
    local found_models=0
    for script in "${TERMUX_PKG_SRCDIR}/models/"*.sh; do
        if [ -f "$script" ]; then
            local basename=$(basename "$script")
            # Skip if it's the download-ggml-model.sh (already installed above)
            if [ "$basename" != "download-ggml-model.sh" ]; then
                echo "  Installing: $basename"
                install -Dm755 "$script" \
                    "${TERMUX_PREFIX}/share/whisper-cpp/$basename"
                found_models=$((found_models + 1))
            fi
        fi
    done
    if [ $found_models -eq 0 ]; then
        echo "  No additional model scripts found"
    fi
    
    # Install any shell scripts from examples/ directory
    echo "Checking for scripts in ${TERMUX_PKG_SRCDIR}/examples/"
    local found_examples=0
    if [ -d "${TERMUX_PKG_SRCDIR}/examples" ]; then
        for script in "${TERMUX_PKG_SRCDIR}/examples/"*.sh; do
            if [ -f "$script" ]; then
                local basename=$(basename "$script")
                local scriptname="${basename%.sh}"
                echo "  Installing: $basename -> whisper-${scriptname}"
                install -Dm755 "$script" \
                    "${TERMUX_PREFIX}/bin/whisper-${scriptname}"
                found_examples=$((found_examples + 1))
            fi
        done
    fi
    if [ $found_examples -eq 0 ]; then
        echo "  No example scripts found"
    fi
    
    # Install any scripts from scripts/ directory  
    echo "Checking for scripts in ${TERMUX_PKG_SRCDIR}/scripts/"
    local found_scripts=0
    if [ -d "${TERMUX_PKG_SRCDIR}/scripts" ]; then
        mkdir -p "${TERMUX_PREFIX}/share/whisper-cpp"
        for script in "${TERMUX_PKG_SRCDIR}/scripts/"*.sh; do
            if [ -f "$script" ]; then
                local basename=$(basename "$script")
                echo "  Installing: $basename"
                install -Dm755 "$script" \
                    "${TERMUX_PREFIX}/share/whisper-cpp/$basename"
                found_scripts=$((found_scripts + 1))
            fi
        done
    fi
    if [ $found_scripts -eq 0 ]; then
        echo "  No utility scripts found"
    fi
    
    echo "=== whisper-cpp: Script installation complete ==="
    mkdir -p ${TERMUX_PREFIX}/lib
    
    # Find and copy all .so files from the entire build directory
    echo "Searching for all .so files in build directory..."
    find ${TERMUX_PKG_BUILDDIR} -name "*.so" -type f -exec cp -fv {} ${TERMUX_PREFIX}/lib/ \;
    echo "=== Library copy complete ==="
}
