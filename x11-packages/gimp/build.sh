TERMUX_PKG_HOMEPAGE=https://www.gimp.org/
TERMUX_PKG_DESCRIPTION="GNU Image Manipulation Program"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.2"
TERMUX_PKG_SRCURL=git+https://gitlab.gnome.org/GNOME/gimp
TERMUX_PKG_SHA256=08cf8d4b4e01ba4df675127945f87041b40615e0c564672090280f48af1d9f2f
TERMUX_PKG_GIT_BRANCH="GIMP_${TERMUX_PKG_VERSION//./_}"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="aalib, appstream-glib, atk, babl, fontconfig, freetype, gdk-pixbuf, gegl, gexiv2, ghostscript, gimp-data, glib, glib-networking, gtk3, harfbuzz, hicolor-icon-theme, json-glib, libandroid-execinfo, libandroid-shmem, libbz2, libc++, libcairo, libheif, libjpeg-turbo, libjxl, libmypaint, libpng, librsvg, libtiff, libwebp, libxcursor, libxmu, libxpm, littlecms, mypaint-brushes, openexr, openjpeg, pango, poppler, poppler-data, pygobject, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcheck-update=no
-Dvala=disabled
-Dcan-crosscompile-gir=true
-Dopenmp=disabled
-Dicc-directory=$TERMUX_PREFIX/share/color/icc
-Dlibunwind=false
-Dlibbacktrace=false
-Dmng=disabled
-Dwmf=disabled
-Dgi-docgen=disabled
-Djavascript=disabled
-Dlua=false
-Dbug-report-url=https://github.com/termux/termux-packages/issues/new?template=01-bug-report.yml
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum | cut -d" " -f1)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}" ]]; then
		termux_error_exit "
		Checksum mismatch for source files!
		Expected = ${TERMUX_PKG_SHA256}
		Actual   = ${s}
		"
	fi
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_proot
	CXXFLAGS+=" -Wno-error=register"
	LDFLAGS+=" -landroid-shmem -lm"
	export GLIB_COMPILE_RESOURCES=glib-compile-resources

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		# Gimp requires using cross-compiled or prebuilt gimp during cross-compilation which is hard to achive here
		# gimp is required only to generate splash image, so it will be fine to use official appimage.
		termux_download https://download.gimp.org/gimp/v3.0/linux/GIMP-3.0.2-x86_64.AppImage "$TERMUX_PKG_CACHEDIR/gimp.appimage" 1f22295ba607b207f2230483ccd92640299f47c132f013a3cf34af3d26c91546
		chmod +x "$TERMUX_PKG_CACHEDIR/gimp.appimage"
		[ -d $TERMUX_PKG_CACHEDIR/squashfs-root ] || (cd "$TERMUX_PKG_CACHEDIR"; "$TERMUX_PKG_CACHEDIR/gimp.appimage" --appimage-extract)

		# For some reason gimp-console-3.0 always tries to open X11 display.
		# See https://gitlab.gnome.org/GNOME/gimp/-/issues/13537
		# sed -i 's/org.gimp.GIMP.Stable/gimp-console-3.0/g' "$TERMUX_PKG_CACHEDIR/squashfs-root/AppRun" ||:
		# "$TERMUX_PKG_CACHEDIR/squashfs-root/AppRun" -nidfs "$TERMUX_PKG_SRCDIR/gimp-data/images/gimp-splash.xcf.gz" \
		#	--batch-interpreter python-fu-eval -b - --quit < "$TERMUX_PKG_SRCDIR/gimp-data/images/export-splash.py" > "$TERMUX_PKG_SRCDIR/gimp-data/images/gimp-splash.png"

		# As a workaround we will simply extract splash from appimage.
		cp "$TERMUX_PKG_CACHEDIR/squashfs-root/usr/share/gimp/3.0/images/gimp-splash.png" "$TERMUX_PKG_SRCDIR/gimp-data/images/gimp-splash.png"

		mkdir -p "$TERMUX_PKG_TMPDIR/bin"
		# gtk-encode-symbolic-svg is required but not installed in our docker image.
		cat > "$TERMUX_PKG_TMPDIR/bin/gtk-encode-symbolic-svg" <<-HERE
			#!$(command -v bash)
			# proot will append its own LD_LIBRARY_PATH which is incompatible with bionic
			exec $(command -v termux-proot-run) env LD_PRELOAD= LD_LIBRARY_PATH= $TERMUX_PREFIX/bin/gtk-encode-symbolic-svg "\$@"
		HERE
		cat > "$TERMUX_PKG_TMPDIR/bin/gimp-console-3.0" <<-HERE
			#!$(command -v bash)
			unset GI_TYPELIB_PATH LD_LIBRARY_PATH
			exec $TERMUX_PKG_CACHEDIR/squashfs-root/AppRun "\$@"
		HERE
		# for some reason deb-elf-get-needed fails on x86_64
		cat > "$TERMUX_PKG_TMPDIR/bin/g-ir-scanner" <<-HERE
			#!$(command -v bash)
			exec $(unset PKG_CONFIG_DIR PKG_CONFIG_LIBDIR; /usr/bin/pkg-config --variable=g_ir_scanner gobject-introspection-1.0) "\$@" --use-ldd-wrapper=$(command -v ldd)
		HERE
		# meson cross-file already has pkg-config defined so termux's pkg-config wrapper will be used for cross-compilation.
		# but we must have regular pkg-config to allow meson linking `native: true` targets.
		# Also we should override host's g-ir-scanner
		cat > "$TERMUX_PKG_TMPDIR/bin/pkg-config" <<-HERE
			#!$(command -v bash)
			unset PKG_CONFIG_DIR PKG_CONFIG_LIBDIR
			if [ "\$1" = "--variable=g_ir_scanner" ] && [ "\$2" = "gobject-introspection-1.0" ]; then
				echo "$TERMUX_PKG_TMPDIR/bin/g-ir-scanner"
				exit 0
			fi
			exec /usr/bin/pkg-config "\$@"
		HERE
		chmod +x "$TERMUX_PKG_TMPDIR/bin"/*
		PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
	fi
}

termux_step_post_configure() {
	sed -i 's/#define HAVE_OPENMP/#undef HAVE_OPENMP/g' "$TERMUX_PKG_BUILDDIR/config.h"
}
