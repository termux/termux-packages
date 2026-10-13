TERMUX_PKG_HOMEPAGE=http://www.ossp.org/pkg/lib/uuid/
TERMUX_PKG_DESCRIPTION="ISO-C:1999 uuid generator supporting DCE 1.1, ISO/IEC 11578:1996 and RFC 4122."
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/uuid/uuid-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="ossp-uuid-dev"
TERMUX_PKG_REPLACES="ossp-uuid-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--includedir=$TERMUX_PREFIX/include/ossp-uuid"

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(curl --silent http://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/uuid/ | \
		sed -n 's|.*href="uuid-\([0-9.]*\)\.tar\.gz".*|\1|p' | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	export ac_cv_va_copy=C99
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	if [ ! -e "lib/libossp-uuid.so.16" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	# Check if SONAME is properly set:
	if ! readelf -d lib/libossp-uuid.so | grep -q '(SONAME).*\[libossp-uuid\.so\.'; then
		termux_error_exit "SONAME for libossp-uuid.so is not properly set."
	fi
}
