TERMUX_PKG_HOMEPAGE=https://skarnet.org/software/skalibs/
TERMUX_PKG_DESCRIPTION="A set of general-purpose C programming libraries"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION=2.16.0.0
TERMUX_PKG_SRCURL="https://skarnet.org/software/skalibs/skalibs-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=90a3deda94a40d7d6a4495fe6feaf91c0185e0428d59cbd150a1a468741269aa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS='AR:=$(AR) RANLIB:=$(RANLIB) STRIP:=$(STRIP)'

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2.16

	local v=$(sed -En 's/^version=([0-9]+\.[0-9]+)\..*/\1/p' package/info)
	if [ ! "${v}" ] || [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_configure() {
	./configure \
		--prefix="${TERMUX__PREFIX}" \
		--host="${TERMUX_HOST_PLATFORM}" \
		--disable-rpath \
		--enable-shared \
		--enable-static \
		--enable-pkgconfig \
		--libdir="${TERMUX__PREFIX__LIB_DIR}" \
		--includedir="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--with-sysdep-devurandom=yes \
		--with-sysdep-posixspawnearlyreturn=no \
		--with-sysdep-procselfexe=/proc/self/exe \
		--with-sysdep-selectinfinite=yes
}
