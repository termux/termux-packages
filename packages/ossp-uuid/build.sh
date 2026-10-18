TERMUX_PKG_HOMEPAGE=https://sr.ht/~nabijaczleweli/ossp
TERMUX_PKG_DESCRIPTION="ISO-C:1999 uuid generator supporting DCE 1.1, ISO/IEC 11578:1996 and RFC 4122."
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_LICENSE_FILE="README, LICENSES/0BSD.txt"
TERMUX_PKG_MAINTAINER="@termux"
# Revbump revdeps after updating
TERMUX_PKG_VERSION=1.6.6
TERMUX_PKG_SRCURL=https://git.sr.ht/~nabijaczleweli/ossp-uuid/archive/UUID_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=f807d37d2bf8c668275ac300d7b22f273339edc67887b411f0f55a824fbe8f08
TERMUX_PKG_DEPENDS="libmd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="ossp-uuid-dev"
TERMUX_PKG_REPLACES="ossp-uuid-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--includedir=$TERMUX_PREFIX/include/ossp-uuid
--with-libname=libossp-uuid
"

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(git ls-remote --tags https://git.sr.ht/~nabijaczleweli/ossp-uuid | \
		sed -n 's|.*refs/tags/UUID_\([0-9]*_[0-9]*_[0-9]*\)$|\1|p' | tr _ . | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=16

	local e=$(sed -En 's/^UUID_VERSION_LIBTOOL=([0-9]+):.*/\1/p' configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "${e}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	rm -rf "${TERMUX_PREFIX}/share/man"
}
