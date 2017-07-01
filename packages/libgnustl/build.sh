TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/onlinedocs/libstdc++/
TERMUX_PKG_DESCRIPTION="The GNU Standard C++ Library (a.k.a. libstdc++-v3), necessary on android since the system libstdc++.so is stripped down"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
# Since every C++ package links against this by default (due
# to the libstdc++.so -> libgnustl_shared.so setup in
# build-package.sh) this package is considered essential,
# and other packages does not need to declare explicit
# dependency on it.
TERMUX_PKG_ESSENTIAL=yes

termux_step_post_massage () {
	# We take the library here after massage step to
	# avoid stripping the library after running termux-elf-cleaner,
	# which causes a broken library (program compiled on the
	# device linking to the library will segfault, at least on aarch64).
	mkdir lib
	cp $TERMUX_PREFIX/lib/libgnustl_shared.so lib/
}
