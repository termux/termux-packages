# x11-packages
# Unstable development version.
TERMUX_PKG_HOMEPAGE=https://www.gimp.org/
TERMUX_PKG_DESCRIPTION="GNU Image Manipulation Program"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.99
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.12
TERMUX_PKG_SRCURL=https://download.gimp.org/mirror/pub/gimp/v${_MAJOR_VERSION}/gimp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7ba1b032ea520d540e4acad3da16d8637fe693743fdb36e0121775eea569f6a3
TERMUX_PKG_DEPENDS="aalib, appstream-glib, atk, babl, fontconfig, freetype, gdk-pixbuf, gegl, gexiv2, ghostscript, glib, glib-networking, gtk3, harfbuzz, hicolor-icon-theme, iso-codes, json-glib, libandroid-execinfo, libandroid-shmem, libarchive, libbz2, libcairo, libheif, libjpeg-turbo, libjxl, liblzma, libmypaint, libpng, librsvg, libtiff, libwebp, libx11, libxcursor, libxext, libxfixes, libxmu, libxpm, littlecms, mypaint-brushes, openexr2, openjpeg, pango, poppler, poppler-data, shared-mime-info, zlib, pygobject, python"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_CONFLICTS="gimp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcheck-update=no
-Dbug-report-url=https://github.com/termux/termux-packages/issues
-Dicc-directory=$TERMUX_PREFIX/share/color/icc
-Dwith-sendmail=$TERMUX_PREFIX/bin/sendmail
-Dlibunwind=false
-Dlibbacktrace=false
-Dmng=disabled
-Dwmf=disabled
-Dcan-crosscompile-gir=true
-Dgi-docgen=disabled
-Djavascript=false
-Dlua=false
"

termux_step_pre_configure() {
	termux_setup_gir

	LDFLAGS+=" -landroid-execinfo -landroid-shmem -lm"
	export PKG_CONFIG_PATH=$TERMUX_PREFIX/share/pkgconfig
	export CC_FOR_BUILD=$(basename $CC_FOR_BUILD)
}

termux_step_post_configure() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local bin=$TERMUX_PKG_BUILDDIR/_bin
		rm -rf $bin
		local pkg_config_for_build=/usr/bin/pkg-config
		unset PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
		$CC_FOR_BUILD \
			$($pkg_config_for_build glib-2.0 --cflags) \
			$($pkg_config_for_build librsvg-2.0 --cflags) \
			$TERMUX_PKG_SRCDIR/tools/colorsvg2png.c \
			-o tools/colorsvg2png \
			$($pkg_config_for_build glib-2.0 --libs) \
			$($pkg_config_for_build librsvg-2.0 --libs)
		mkdir -p $bin
		cat > $bin/$CC_FOR_BUILD <<-EOF
			#!$(command -v sh)
			for f in "\$@"; do
				case "\${f}" in
					tools/colorsvg2png ) exit 0 ;;
				esac
			done
			exec $(command -v $CC_FOR_BUILD) "\$@"
		EOF
		chmod 0700 $bin/$CC_FOR_BUILD
		export PATH="$bin:$PATH"
	fi
}
