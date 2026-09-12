TERMUX_PKG_HOMEPAGE=https://www.darktable.org/
TERMUX_PKG_DESCRIPTION="Virtual lighttable and darkroom for photographers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="5.6.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/darktable-org/darktable/releases/download/release-${TERMUX_PKG_VERSION}/darktable-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e8b84ac98b0b689a244e4036c4b56394c1d58ce2d9abc05e0a060ef9f756dc36
TERMUX_PKG_DEPENDS="exiv2, gdk-pixbuf, glib, graphicsmagick, gtk3, imath, json-glib, lensfun, libandroid-glob, libavif, libc++, libcairo, libcurl, libheif, libicu, libjpeg-turbo, libjxl, libllvm, libpng, libpugixml, librsvg, libsqlite, libtiff, libwebp, libxml2, littlecms, ltrace, lua54, openexr, openjpeg, pango, portmidi, potrace, zlib"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBINARY_PACKAGE_BUILD=ON
-DUSE_GMIC=OFF
-DUSE_OPENCL=OFF
-DUSE_OPENMP=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/darktable"

	LDFLAGS+=" -landroid-glob"
}
