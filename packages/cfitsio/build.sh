TERMUX_PKG_HOMEPAGE=https://heasarc.gsfc.nasa.gov/fitsio/
TERMUX_PKG_DESCRIPTION="a library of C and Fortran subroutines for reading and writing data files in FITS (Flexible Image Transport System) data format"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="licenses/License.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/HEASARC/cfitsio/archive/refs/tags/cfitsio-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=fb09b18638b0a71fa3c2612aac4fafd29cae8642266ba690803eb95f037a5268
TERMUX_PKG_DEPENDS="curl, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DM_LIB=
-DUTILS=OFF
-DTESTS=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		lib/libcfitsio.so.10
	)
	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		if [[ ! -e "${f}" ]]; then
			termux_error_exit <<- EOF
				SOVERSION guard check failed.
				Expected: $f
				Found: $(readlink "${f%.*}")
			EOF
		fi
	done
}
