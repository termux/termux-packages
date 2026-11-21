TERMUX_PKG_HOMEPAGE=https://skarnet.org/software/s6-portable-utils/
TERMUX_PKG_DESCRIPTION="A set of tiny general Unix utilities"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION=2.3.1.2
TERMUX_PKG_SRCURL="https://skarnet.org/software/s6-portable-utils/s6-portable-utils-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cfb90186d0c0eb204e1e5c6f9379e99413c546bccf38bb6e76177f82371aa3aa
TERMUX_PKG_DEPENDS="skalibs"
TERMUX_PKG_BUILD_DEPENDS="skalibs-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# Skarnet packages do *not* use GNU Autotools
	# https://github.com/skarnet/s6-portable-utils/blob/refs/tags/v2.3.1.2/configure
	./configure \
		--prefix="${TERMUX__PREFIX}" \
		--host="${TERMUX_HOST_PLATFORM}" \
		--enable-multicall \
		--bindir="${TERMUX__PREFIX__BIN_DIR}" \
		--includedir="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--with-sysdeps="${TERMUX__PREFIX__LIB_DIR}/skalibs/sysdeps" \
		--with-include="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--with-lib="${TERMUX__PREFIX__LIB_DIR}"
}
