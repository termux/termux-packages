TERMUX_PKG_HOMEPAGE=https://www.unidata.ucar.edu/software/netcdf/
TERMUX_PKG_DESCRIPTION="NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.9.1
TERMUX_PKG_SRCURL=https://github.com/Unidata/netcdf-c/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4ee8d5f6b50a1eb4ad4c10f24531e36261fd1882410fb08435eb2ddfd49a0908
TERMUX_PKG_DEPENDS="libandroid-execinfo, libcurl, zlib"
TERMUX_PKG_BREAKS="netcdf-c-dev"
TERMUX_PKG_REPLACES="netcdf-c-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-hdf5"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=19

	local e=$(sed -En 's/.*\s+netCDF_SO_VERSION="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
