TERMUX_PKG_HOMEPAGE=https://github.com/mpimd-csc/qrupdate-ng
TERMUX_PKG_DESCRIPTION="A Library for Fast Updating of QR and Cholesky Decompositions."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:1.2.0"
TERMUX_PKG_SRCURL=https://github.com/mpimd-csc/qrupdate-ng/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=452f1fe58ca5ad42f8bb6e11a86c28f94baf852a38699ddd44c00d11ae0b7c0b
TERMUX_PKG_DEPENDS="libopenblas"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DCMAKE_SYSTEM_NAME=Linux
"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_flang
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libqrupdate.so.1
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
