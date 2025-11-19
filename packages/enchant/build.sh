TERMUX_PKG_HOMEPAGE=https://rrthomas.github.io/enchant/
TERMUX_PKG_DESCRIPTION="Wraps a number of different spelling libraries and programs with a consistent interface"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.12"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rrthomas/enchant/releases/download/v${TERMUX_PKG_VERSION}/enchant-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=20e5fab2ca0f95ba9d1ef5052fe5b028e3e1d66d4cdea6b9adfcbd3e524c2a09
TERMUX_PKG_DEPENDS="aspell, glib, hunspell, libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-relocatable"

termux_step_pre_configure() {
	local _libgcc="$($CC -print-libgcc-file-name)"
	LDFLAGS+=" -L$(dirname $_libgcc) -l:$(basename $_libgcc)"
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libenchant-2.so"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
