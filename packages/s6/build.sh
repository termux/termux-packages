TERMUX_PKG_HOMEPAGE=https://skarnet.org/software/s6/
TERMUX_PKG_DESCRIPTION="A small and secure supervision software suite"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION=2.15.1.1
TERMUX_PKG_SRCURL="https://skarnet.org/software/s6/s6-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=62080839eb5b04d51efd4ef6e7b43e29b5d0576efce9eb319ace32ea90c05931
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="execline, skalibs"
TERMUX_PKG_BUILD_DEPENDS="execline-static, skalibs-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS='AR:=$(AR) RANLIB:=$(RANLIB) STRIP:=$(STRIP)'

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2.15

	if [[ ! "${TERMUX_PKG_VERSION}" =~ ^${_SOVERSION//./\.}\. ]]; then
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
		--bindir="${TERMUX__PREFIX__BIN_DIR}" \
		--libexecdir="${TERMUX__PREFIX__LIBEXEC_DIR}" \
		--libdir="${TERMUX__PREFIX__LIB_DIR}" \
		--dynlibdir="${TERMUX__PREFIX__LIB_DIR}" \
		--includedir="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--sysconfdir="${TERMUX__PREFIX__ETC_DIR}" \
		--with-sysdeps="${TERMUX__PREFIX__LIB_DIR}/skalibs/sysdeps" \
		--with-include="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--with-lib="${TERMUX__PREFIX__LIB_DIR}" \
		--with-dynlib="${TERMUX__PREFIX__LIB_DIR}"
}
