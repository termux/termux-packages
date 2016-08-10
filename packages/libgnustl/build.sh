TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/onlinedocs/libstdc++/
TERMUX_PKG_DESCRIPTION="The GNU Standard C++ Library (a.k.a. libstdc++-v3), necessary on android since the system libstdc++.so is stripped down"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_BUILD_REVISION=4
# Since every C++ package links against this by default (due
# to the libstdc++.so -> libgnustl_shared.so setup in
# build-package.sh) this package is considered essential,
# and other packages does not need to declare explicit
# dependency on it.
TERMUX_PKG_ESSENTIAL=yes

termux_step_make_install () {
	# Just bump timestamp to have it packaged.
	touch $TERMUX_PREFIX/lib/libgnustl_shared.so
}
