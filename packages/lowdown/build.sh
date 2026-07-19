TERMUX_PKG_HOMEPAGE="https://kristaps.bsd.lv/lowdown"
TERMUX_PKG_DESCRIPTION="Markdown utilities and library (fork of hoedown -> sundown -> libsoldout)"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL="https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1bf17678b8813fa12defa731e61c15145558b9f7f1296b0a6fdcfdda0caba468
#TERMUX_PKG_BUILD_DEPENDS="libseccomp" ## it is merely a checkdepends for now and we dont run check during build
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install install_libs" ## add "regress" target if one wanna run check
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local v=$(sed -n 's/^LIBVER[[:space:]]*=[[:space:]]*\([0-9]*\)$/\1/p' Makefile)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed. Expected ${_SOVERSION}, got ${v}."
	fi
}

termux_step_host_build() {
	# We can not build bmake for host because it has a bmake makefile. Classic chicken and egg problem.
	DESTINATION="${TERMUX_PKG_HOSTBUILD_DIR}/prefix" \
	termux_download_ubuntu_packages bmake

	ln -s "${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin/bmake" "${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin/make"
}

termux_step_configure() {
	export MAKESYSPATH="${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/share/bmake/mk-bmake/"
	export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin:${PATH}"

	## avoid hard-linking during make
	sed -Ee 's%^([\t ]*ln) -f (lowdown lowdown-diff)$%\1 -srf \2%' -i Makefile

	## not an autoconf script
	./configure \
		LDFLAGS="$LDFLAGS" \
		CPPFLAGS="$CPPFLAGS" \
		PREFIX="$TERMUX_PREFIX" \
		MANDIR="$TERMUX_PREFIX/share/man"
}
