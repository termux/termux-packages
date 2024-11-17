TERMUX_PKG_HOMEPAGE=https://tukaani.org/xz/
TERMUX_PKG_DESCRIPTION="XZ-format compression library"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.GPLv2, COPYING.GPLv3, COPYING.LGPLv2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.6.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tukaani-project/xz/releases/download/v$TERMUX_PKG_VERSION/xz-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=db0590629b6f0fa36e74aea5f9731dc6f8df068ce7b7bafa45301832a5eebc3a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="liblzma-dev"
TERMUX_PKG_REPLACES="liblzma-dev"
TERMUX_PKG_ESSENTIAL=true
# seccomp prevents SYS_landlock_create_ruleset
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-sandbox=no
"

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/liblzma.so.5"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done

	# Check if SONAME is properly set:
	if ! readelf -d lib/liblzma.so | grep -q '(SONAME).*\[liblzma\.so\.'; then
		termux_error_exit "SONAME of liblzma.so is not properly set."
	fi
}
