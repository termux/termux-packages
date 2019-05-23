TERMUX_PKG_HOMEPAGE=http://www.softsynth.com/pforth/
TERMUX_PKG_DESCRIPTION="Portable Forth in C"
TERMUX_PKG_LICENSE="Public Domain"
_COMMIT=ee8dc9e9e0f59b8e38dec3732caefe9f3af2b431
TERMUX_PKG_VERSION=20180513
TERMUX_PKG_SHA256=3cf472bb944aa53b0eb0b93d021c8c2c0eff18dd2e3e54daddaf4af342e441ea
TERMUX_PKG_SRCURL=https://github.com/philburk/pforth/archive/${_COMMIT}.zip
TERMUX_PKG_HOSTBUILD=yes

termux_step_post_configure() {
	# Avoid caching the host build as it differs between arches
	# and is quite fast here anyway:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_host_build() {
	local M32=""
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		M32="-m32"
	fi
	cp -Rf $TERMUX_PKG_SRCDIR/* .
	cd build/unix
	CC="gcc $M32" make pfdicdat.h
	CC="gcc $M32" make all
}

termux_step_pre_configure() {
	for file in pfdicdat.h pforth; do
		cp $TERMUX_PKG_HOSTBUILD_DIR/build/unix/$file $TERMUX_PKG_SRCDIR/build/unix/$file
		touch -d "next hour" $TERMUX_PKG_SRCDIR/build/unix/$file
	done

	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build/unix
	export CC="$CC $CFLAGS $LDFLAGS"
}
termux_step_make_install() {
	cp $TERMUX_PKG_BUILDDIR/pforth_standalone $TERMUX_PREFIX/bin/pforth
}
