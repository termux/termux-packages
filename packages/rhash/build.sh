TERMUX_PKG_HOMEPAGE=https://github.com/rhash/RHash
TERMUX_PKG_DESCRIPTION="Console utility for calculation and verification of magnet links and a wide range of hash sums"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.5"
TERMUX_PKG_SRCURL=https://github.com/rhash/RHash/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6db837e7bbaa7c72c5fd43ca5af04b1d370c5ce32367b9f6a1f7b49b2338c09a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_CONFLICTS="librhash, rhash-dev"
TERMUX_PKG_REPLACES="librhash, rhash-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	CFLAGS="-DOPENSSL_RUNTIME -DSYSCONFDIR=\"${TERMUX_PREFIX}/etc\" $CPPFLAGS $CFLAGS"
	./configure \
		--prefix=$TERMUX_PREFIX \
		--disable-static \
		--enable-lib-static \
		--enable-lib-shared \
		--cc=$CC
}

termux_step_make() {
	make -j $TERMUX_PKG_MAKE_PROCESSES \
		ADDCFLAGS="$CFLAGS" \
		ADDLDFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	make install install-pkg-config
	make -C librhash install-lib-headers

	ln -sf $TERMUX_PREFIX/lib/librhash.so.1 $TERMUX_PREFIX/lib/librhash.so
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/librhash.so.1"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
