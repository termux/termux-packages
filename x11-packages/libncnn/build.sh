TERMUX_PKG_HOMEPAGE=https://github.com/Tencent/ncnn
TERMUX_PKG_DESCRIPTION="A high-performance neural network inference framework optimized for the mobile platform"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20250503"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/Tencent/ncnn/releases/download/${TERMUX_PKG_VERSION}/ncnn-${TERMUX_PKG_VERSION}-full-source.zip
TERMUX_PKG_SHA256=b3190d1b6beae3aac30fa99f4d3fd89a2b47a010b888d2d2389189784743a690
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="abseil-cpp, glslang, libc++, libandroid-stub, libprotobuf, python-pip, python-numpy, python-opencv-python, vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, vulkan-loader-android"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, pybind11"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DNCNN_AVX=OFF
-DNCNN_BUILD_BENCHMARK=OFF
-DNCNN_BUILD_EXAMPLES=OFF
-DNCNN_BUILD_TESTS=OFF
-DNCNN_BUILD_TOOLS=OFF
-DNCNN_DISABLE_EXCEPTION=OFF
-DNCNN_DISABLE_RTTI=OFF
-DNCNN_ENABLE_LTO=ON
-DNCNN_OPENMP=ON
-DNCNN_PYTHON=ON
-DNCNN_SHARED_LIB=OFF
-DNCNN_SIMPLEOCV=ON
-DNCNN_SIMPLEOMP=ON
-DNCNN_SIMPLESTL=OFF
-DNCNN_SYSTEM_GLSLANG=ON
-DNCNN_VULKAN=ON
-DVulkan_LIBRARY=${TERMUX_PREFIX}/lib/libvulkan.so
-DVulkan_INCLUDE_DIRS=${TERMUX_PREFIX}/include
"

# The original "termux_extract_src_archive" always strips the first components
# but the source of libncnn is directly under the root directory of the zip file
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_protobuf

	CXXFLAGS+=" -std=c++17"
	LDFLAGS+=" -fopenmp -static-openmp"
	LDFLAGS+=" $("${TERMUX_SCRIPTDIR}/packages/libprotobuf/interface_link_libraries.sh")"
	LDFLAGS+=" -lutf8_range -lutf8_validity"
	LDFLAGS+=" -landroid -ljnigraphics -llog"
}

termux_step_post_make_install() {
	# the build system can only build static or shared
	# at a given time
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DNCNN_BUILD_TOOLS=ON
	-DNCNN_SHARED_LIB=ON
	"
	termux_step_configure
	termux_step_make
	termux_step_make_install

	pushd python
	pip install --no-deps . --prefix "${TERMUX_PREFIX}"
	popd

	return

	# below are testing tools that should not be packaged
	# as they can be >100MB
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DNCNN_BUILD_BENCHMARK=ON
	-DNCNN_BUILD_EXAMPLES=ON
	-DNCNN_BUILD_TESTS=ON
	-DNCNN_SHARED_LIB=OFF
	"
	termux_step_configure
	termux_step_make

	local tools_dir="${TERMUX_PREFIX}/lib/ncnn"

	local benchmarks=$(find benchmark -mindepth 1 -maxdepth 1 -type f | sort)
	for benchmark in ${benchmarks}; do
		case "$(basename "${benchmark}")" in
			*[Cc][Mm]ake*) continue ;;
			*.cpp*) continue ;;
			*.md) continue ;;
			*.*) install -v -Dm644 "${benchmark}" -t "${tools_dir}/benchmark" ;;
			*) install -v -Dm755 "${benchmark}" -t "${tools_dir}/benchmark" ;;
		esac
	done

	local examples=$(find examples -mindepth 1 -maxdepth 1 -type f | sort)
	for example in ${examples}; do
		case "$(basename "${example}")" in
			*[Cc][Mm]ake*) continue ;;
			*.cpp*) continue ;;
			*.*) install -v -Dm644 "${example}" -t "${tools_dir}/examples" ;;
			*) install -v -Dm755 "${example}" -t "${tools_dir}/examples" ;;
		esac
	done

	local tests=$(find tests -mindepth 1 -maxdepth 1 -type f | sort)
	for test in ${tests}; do
		case "$(basename "${test}")" in
			*[Cc][Mm]ake*) continue ;;
			*.cpp*) continue ;;
			*.h) continue ;;
			*.py) continue ;;
			*) install -v -Dm755 "${test}" -t "${tools_dir}/tests" ;;
		esac
	done
}
