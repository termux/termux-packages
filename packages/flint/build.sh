TERMUX_PKG_HOMEPAGE=http://www.flintlib.org
TERMUX_PKG_DESCRIPTION="C library for doing number theory"
TERMUX_PKG_LICENSE="LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.0"
TERMUX_PKG_SRCURL="https://github.com/flintlib/flint/releases/download/v$TERMUX_PKG_VERSION/flint-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9497679804dead926e3affeb8d4c58739d1c7684d60c2c12827550d28e454a33
TERMUX_PKG_DEPENDS="blas-openblas, libgmp, libmpfr"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_AUTO_UPDATE=true
# ENABLE_ARCH is for adding `-march` argument to compiler; -DENABLE_ARCH=NO avoids that,
# allowing Termux's own `-march` setting from termux_setup_toolchain_* to apply
# Disable AVX2 like Arch Linux, because Arch Linux documented an issue related to it:
# https://gitlab.archlinux.org/archlinux/packaging/packages/flint/-/work_items/1
# (ENABLE_AVX2=OFF will reportedly be necessary to avoid Sagemath crashing)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DENABLE_ARCH=NO
-DENABLE_AVX2=OFF
"

termux_step_pre_configure() {
	# upstream discourages the use of the CMakeLists.txt on UNIX-like platforms,
	# but Arch Linux forcibly runs the CMakeLists.txt anyway using this,
	# so try to follow Arch Linux's example first unless a problem occurs.
	# https://gitlab.archlinux.org/archlinux/packaging/packages/flint/-/blob/0f05d716db948e16d699749ee5c71dab43461857/PKGBUILD#L26
	sed -e 's|NOT WIN32|FALSE|' -i CMakeLists.txt

	if [[ "$TERMUX_PKG_API_LEVEL" -lt 28 ]]; then
		CPPFLAGS+=" -Daligned_alloc=memalign"
	fi
}
