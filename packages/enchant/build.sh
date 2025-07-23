TERMUX_PKG_HOMEPAGE=https://rrthomas.github.io/enchant/
TERMUX_PKG_DESCRIPTION="Wraps a number of different spelling libraries and programs with a consistent interface"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.11"
TERMUX_PKG_SRCURL=https://github.com/rrthomas/enchant/releases/download/v${TERMUX_PKG_VERSION}/enchant-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fc6694a496848fb1204169c0cc6b844beec49fddd547bbf2bd2a7e33322c55d9
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
