TERMUX_PKG_HOMEPAGE=https://github.com/dofuuz/python-soxr
TERMUX_PKG_DESCRIPTION="Fast and high quality sample-rate conversion library for Python"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="DevGitPit <106362593+DevGitPit@users.noreply.github.com>"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dofuuz/python-soxr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9b84d47e85dab025c380582016607db25f12b81c1e12aa54539842c5997948a
TERMUX_PKG_DEPENDS="python, python-numpy, python-pip, libc++, libsoxr"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# nanobind's stub generation dlopen()s the freshly-built module in-process
	# to introspect it. This is fundamentally incompatible with cross-compiling
	# (the host interpreter can't load a target-arch .so at all), and CMake's
	# own CMAKE_CROSSCOMPILING guard for this doesn't reliably evaluate true
	# in this build. Skip stub generation unconditionally.
	sed -i 's/if (NOT CMAKE_CROSSCOMPILING)/if (FALSE)/' CMakeLists.txt
}

termux_step_configure() {
	termux_setup_cmake
	export SETUPTOOLS_SCM_PRETEND_VERSION="${TERMUX_PKG_VERSION}"
	export SKBUILD_CMAKE_DEFINE="USE_SYSTEM_LIBSOXR=ON;SOXR_LIBRARY=$TERMUX_PREFIX/lib/libsoxr.so;SOXR_INCLUDE_DIR=$TERMUX_PREFIX/include"

	# Android/bionic doesn't implicitly export host-process symbols to
	# dlopen'd extensions the way glibc does with -rdynamic, so the compiled
	# extension can't resolve core CPython C-API symbols (e.g.
	# PyExc_ImportError) at runtime without an explicit libpython link.
	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"
}
