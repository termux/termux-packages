TERMUX_PKG_HOMEPAGE=https://mapserver.org/
TERMUX_PKG_DESCRIPTION="MapServer is CGI-based platform for publishing spatial data and interactive mapping applications to the web"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=8.6.6
TERMUX_PKG_SRCURL="https://download.osgeo.org/mapserver/mapserver-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e908e76b65541042042e9c5e4ae16a131f064cf6d3c76e9542c89b25158968c9
TERMUX_PKG_DEPENDS="freetype, gdal, libc++, libcairo, libcurl, libgeos, libiconv, libjpeg-turbo, libpng, libprotobuf-c, libxml2, proj"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_BREAKS="mapserver-dev"
TERMUX_PKG_REPLACES="mapserver-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_STANDARD=14
-DWITH_GDAL=ON
-DWITH_GEOS=ON
-DWITH_OGR=ON
-DWITH_PROJ=ON
-DWITH_POSTGIS=OFF
-DWITH_KML=ON
-DWITH_WCS=ON
-DWITH_SOS=ON
-DWITH_WMS=ON
-DWITH_CLIENT_WMS=ON
-DWITH_WFS=ON
-DWITH_CLIENT_WFS=ON
-DWITH_THREAD_SAFETY=OFF
-DWITH_FCGI=OFF
-DWITH_CAIRO=ON
-DWITH_CURL=ON
-DWITH_MYSQL=OFF
-DWITH_FRIBIDI=OFF
-DWITH_HARFBUZZ=OFF
-DWITH_GIF=OFF
-DWITH_EXEMPI=OFF
"

termux_step_pre_configure() {
	termux_setup_proot
	local protoc_wrapper="${TERMUX_PKG_TMPDIR}/protoc-proot"
	printf '#!/bin/bash\nexec termux-proot-run %s/bin/protoc "$@"\n' "${TERMUX_PREFIX}" > "${protoc_wrapper}"
	chmod +x "${protoc_wrapper}"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPROTOBUFC_COMPILER=${protoc_wrapper}"
}
