TERMUX_PKG_HOMEPAGE=https://github.com/google/benchmark
TERMUX_PKG_DESCRIPTION="Microbenchmark support library for C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.5"
TERMUX_PKG_SRCURL=https://github.com/google/benchmark/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9631341c82bac4a288bef951f8b26b41f69021794184ece969f8473977eaa340
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBENCHMARK_ENABLE_TESTING=OFF
-DBENCHMARK_INSTALL_DOCS=OFF
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
"
# Keep the result comparison tooling (compare.py) but drop
# bazel build files and test fixtures installed alongside it.
TERMUX_PKG_RM_AFTER_INSTALL="
share/googlebenchmark/tools/BUILD.bazel
share/googlebenchmark/tools/libpfm.BUILD.bazel
share/googlebenchmark/tools/gbench/Inputs
"

# NOTE: This library is used for development of DevilutionX upstream
# and downstream code and compatibility with Termux APIs.

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed. SOVERSION is the major version:
	# https://github.com/google/benchmark/blob/main/CMakeLists.txt
	local _SOVERSION=1

	local v=$(sed -En 's/^project \(benchmark VERSION ([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
