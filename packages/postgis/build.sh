TERMUX_PKG_HOMEPAGE=https://postgis.net
TERMUX_PKG_DESCRIPTION="Spatial database extender for PostgreSQL object-relational database"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.8
TERMUX_PKG_SRCURL=https://download.osgeo.org/postgis/source/postgis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=54254fb57070ce44d1da9434f472e0a82df0ef24321c2b9a22c449f756e278e7
TERMUX_PKG_DEPENDS="gdal, json-c, libc++, libiconv, libprotobuf-c, libxml2, pcre, postgresql, proj"

# both configure script and Makefile(s) look for files in current
# directory rather than srcdir, so need to build in source
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Configure script wants to run a cross-compiled program to
	# get proj and protobuf version, which won't work for us.
	local proj_version=$(. $TERMUX_SCRIPTDIR/packages/proj/build.sh; echo $TERMUX_PKG_VERSION)
	# 8.1.1 -> 81
	proj_version=${proj_version:0:1}${proj_version:2:1}
	local protobuf_version=$(. $TERMUX_SCRIPTDIR/packages/libprotobuf-c/build.sh; echo $TERMUX_PKG_VERSION)
	# 1.3.3 -> 1003003
	protobuf_version=${protobuf_version:0:1}00${protobuf_version:2:1}00${protobuf_version:4:1}
	echo "Patching configure script"
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@PROJ_VERSION@|${proj_version}|g" \
		-e "s|@PROTOBUF_VERSION@|${protobuf_version}|g" \
		$TERMUX_PKG_BUILDER_DIR/configure.diff | patch -Np1
}
