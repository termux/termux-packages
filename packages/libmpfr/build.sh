TERMUX_PKG_HOMEPAGE=https://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.0-p4
_MAIN_VERSION=${TERMUX_PKG_VERSION%-p*}
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${_MAIN_VERSION}.tar.xz
TERMUX_PKG_SHA256=06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BREAKS="libmpfr-dev"
TERMUX_PKG_REPLACES="libmpfr-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"

termux_step_post_get_source() {
	if ! [[ $TERMUX_PKG_VERSION = *-p* ]]; then
		return 0
	fi
	local _PATCH_VERSION=${TERMUX_PKG_VERSION#*-p}

	declare -A PATCH_CHECKSUMS

	PATCH_CHECKSUMS[01]=2e465c31689e780a93b24bf2959917443fb882da85b7f1ef23ae53d3de614aa4
	PATCH_CHECKSUMS[02]=e1ef3d4dab999f4e0ad5ee046c3a2823d3a9395fb8092c3dcb85d3fe29994b52
	PATCH_CHECKSUMS[03]=a906f9ed8e4a7230980322a0154702664164690614e5ff55ae7049c3fae55584
	PATCH_CHECKSUMS[04]=ece14ee57596dc2e4f67d2e857c5c6b23d76b20183a50a8b6759b640df001b78

	for PATCH_NUM in $(seq -f '%02g' ${_PATCH_VERSION}); do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/mpfr-${_MAIN_VERSION}-patch${PATCH_NUM}.patch
		termux_download \
			"https://www.mpfr.org/mpfr-${_MAIN_VERSION}/patch${PATCH_NUM}" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$PATCH_NUM]}
		patch -p1 -i $PATCHFILE
	done
	unset PATCH_CHECKSUMS PATCHFILE PATCH_NUM
}
