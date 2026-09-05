TERMUX_PKG_HOMEPAGE=https://skarnet.org/software/execline/
TERMUX_PKG_DESCRIPTION="A small scripting language, to be used with an exec chain"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION=2.9.9.2
TERMUX_PKG_SRCURL="https://skarnet.org/software/execline/execline-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=908ed4db3a6b3a23a205d8fd4cf2a71089156f2aeae0f54656045aafad2dee32
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, skalibs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS='AR:=$(AR) RANLIB:=$(RANLIB) STRIP:=$(STRIP)'

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_configure() {
	./configure \
		--prefix="${TERMUX__PREFIX}" \
		--host="${TERMUX_HOST_PLATFORM}" \
		--disable-rpath \
		--enable-shared \
		--enable-static \
		--enable-pkgconfig \
		--enable-multicall \
		--bindir="${TERMUX__PREFIX__BIN_DIR}" \
		--libdir="${TERMUX__PREFIX__LIB_DIR}" \
		--dynlibdir="${TERMUX__PREFIX__LIB_DIR}" \
		--includedir="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--shebangdir="${TERMUX__PREFIX__BIN_DIR}" \
		--with-sysdeps="${TERMUX__PREFIX__LIB_DIR}/skalibs/sysdeps" \
		--with-include="${TERMUX__PREFIX__INCLUDE_DIR}" \
		--with-lib="${TERMUX__PREFIX__LIB_DIR}" \
		--with-dynlib="${TERMUX__PREFIX__LIB_DIR}"
}
