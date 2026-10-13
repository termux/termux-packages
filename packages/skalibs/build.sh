TERMUX_PKG_HOMEPAGE=https://skarnet.org/software/skalibs/
TERMUX_PKG_DESCRIPTION="A set of general-purpose C programming libraries"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION=2.15.1.0
TERMUX_PKG_SRCURL="https://skarnet.org/software/skalibs/skalibs-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f9c905e74935c6fe911c7e344e3e89d5fbd2014c1a04650b524b15ce9b5635d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS='AR:=$(AR) RANLIB:=$(RANLIB) STRIP:=$(STRIP)'

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
