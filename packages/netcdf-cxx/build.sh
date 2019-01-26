TERMUX_PKG_HOMEPAGE=https://www.unidata.ucar.edu/software/netcdf/
TERMUX_PKG_DESCRIPTION="NetCDF is a set of software libraries and self-describing, machine-independent data formats that support the creation, access, and sharing of array-oriented scientific data"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_SHA256=25da1c97d7a01bc4cee34121c32909872edd38404589c0427fefa1301743f18f
TERMUX_PKG_SRCURL=https://github.com/Unidata/netcdf-cxx4/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libhdf5, libcurl, openssl, libnghttp2, netcdf-c"
