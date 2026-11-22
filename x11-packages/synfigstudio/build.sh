TERMUX_PKG_HOMEPAGE=https://www.synfig.org/
TERMUX_PKG_DESCRIPTION="Open-source 2D vector and timeline-based animation software"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.5"
TERMUX_PKG_SRCURL=https://github.com/synfig/synfig/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bcf859b09bf6eeef5bce7246c00c09fbbe8cf43d9a79b408d83af09334499d4b
TERMUX_PKG_DEPENDS="at-spi2-core, ffmpeg, fftw, fontconfig, freetype, fribidi, gdk-pixbuf, gettext, glib, gtk3, gtkmm3, harfbuzz, imagemagick, imath, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libglibmm-2.4, libjpeg-turbo, libltdl, libpangomm-1.4, libpng, libsigc++-2.0, libxml++-2.6, libxml2, mlt, openexr, pango, zlib"
TERMUX_PKG_RECOMMENDS="python"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_TESTS=OFF
-DWITH_MAGICKPP=ON
-DCMAKE_INSTALL_RPATH=$TERMUX_PREFIX/lib
-DSYNFIG_HOST_BUILD_DIR=$TERMUX_PKG_HOSTBUILD_DIR
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja
	(
		export CC=gcc CXX=g++ AR=ar RANLIB=ranlib STRIP=strip
		local HOST_PREFIX="$TERMUX_PKG_HOSTBUILD_DIR/host-prefix"
		local DEPS_DIR="$TERMUX_PKG_HOSTBUILD_DIR/deps"
		local HOST_SRC="$TERMUX_PKG_HOSTBUILD_DIR/src"
		rm -rf "$HOST_PREFIX" "$DEPS_DIR" "$HOST_SRC"
		mkdir -p "$HOST_PREFIX" "$DEPS_DIR"

		export PKG_CONFIG_PATH="$HOST_PREFIX/lib/pkgconfig"

		# 0. Native Meson runner (avoids termux_setup_meson cross-file)
		local MESON_VER="1.7.0"
		termux_download \
			"https://github.com/mesonbuild/meson/releases/download/${MESON_VER}/meson-${MESON_VER}.tar.gz" \
			"$TERMUX_PKG_CACHEDIR/meson-${MESON_VER}.tar.gz" \
			08efbe84803eed07f863b05092d653a9d348f7038761d900412fddf56deb0284
		tar -xf "$TERMUX_PKG_CACHEDIR/meson-${MESON_VER}.tar.gz" -C "$DEPS_DIR"
		local MESON="python3 $DEPS_DIR/meson-${MESON_VER}/meson.py"

		# 1. libsigc++-2.0
		local SIGC_VER="2.12.1"
		termux_download \
			"https://download.gnome.org/sources/libsigc++/2.12/libsigc++-${SIGC_VER}.tar.xz" \
			"$TERMUX_PKG_CACHEDIR/libsigc++-${SIGC_VER}.tar.xz" \
			a9dbee323351d109b7aee074a9cb89ca3e7bcf8ad8edef1851f4cf359bd50843
		tar -xf "$TERMUX_PKG_CACHEDIR/libsigc++-${SIGC_VER}.tar.xz" -C "$DEPS_DIR"
		$MESON setup "$DEPS_DIR/libsigc++-${SIGC_VER}/build" "$DEPS_DIR/libsigc++-${SIGC_VER}" \
			--prefix="$HOST_PREFIX" \
			--libdir=lib
		ninja -C "$DEPS_DIR/libsigc++-${SIGC_VER}/build" -j"$TERMUX_PKG_MAKE_PROCESSES" install

		# 2. glibmm-2.4 (provides glibmm-2.4 and giomm-2.4)
		local GLIBMM_VER="2.66.7"
		termux_download \
			"https://download.gnome.org/sources/glibmm/2.66/glibmm-${GLIBMM_VER}.tar.xz" \
			"$TERMUX_PKG_CACHEDIR/glibmm-${GLIBMM_VER}.tar.xz" \
			fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3
		tar -xf "$TERMUX_PKG_CACHEDIR/glibmm-${GLIBMM_VER}.tar.xz" -C "$DEPS_DIR"
		$MESON setup "$DEPS_DIR/glibmm-${GLIBMM_VER}/build" "$DEPS_DIR/glibmm-${GLIBMM_VER}" \
			--prefix="$HOST_PREFIX" \
			--libdir=lib
		ninja -C "$DEPS_DIR/glibmm-${GLIBMM_VER}/build" -j"$TERMUX_PKG_MAKE_PROCESSES" install

		# 3. libxml++-2.6
		local XMLPP_VER="2.42.3"
		termux_download \
			"https://download.gnome.org/sources/libxml++/2.42/libxml++-${XMLPP_VER}.tar.xz" \
			"$TERMUX_PKG_CACHEDIR/libxml++-${XMLPP_VER}.tar.xz" \
			74b95302e24dbebc56e97048e86ad0a4121fc82a43e58d381fbe1d380e8eba04
		tar -xf "$TERMUX_PKG_CACHEDIR/libxml++-${XMLPP_VER}.tar.xz" -C "$DEPS_DIR"
		$MESON setup "$DEPS_DIR/libxml++-${XMLPP_VER}/build" "$DEPS_DIR/libxml++-${XMLPP_VER}" \
			--prefix="$HOST_PREFIX" \
			--libdir=lib
		ninja -C "$DEPS_DIR/libxml++-${XMLPP_VER}/build" -j"$TERMUX_PKG_MAKE_PROCESSES" install

		# 4. fftw3
		local FFTW_VER="3.3.10"
		termux_download \
			"https://www.fftw.org/fftw-${FFTW_VER}.tar.gz" \
			"$TERMUX_PKG_CACHEDIR/fftw-${FFTW_VER}.tar.gz" \
			56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467
		tar -xf "$TERMUX_PKG_CACHEDIR/fftw-${FFTW_VER}.tar.gz" -C "$DEPS_DIR"
		cmake -S "$DEPS_DIR/fftw-${FFTW_VER}" -B "$DEPS_DIR/fftw-${FFTW_VER}/build" \
			-GNinja \
			-DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
			-DCMAKE_INSTALL_PREFIX="$HOST_PREFIX" \
			-DCMAKE_INSTALL_LIBDIR=lib \
			-DBUILD_SHARED_LIBS=ON \
			-DBUILD_TESTS=OFF \
			-DENABLE_THREADS=ON
		ninja -C "$DEPS_DIR/fftw-${FFTW_VER}/build" -j"$TERMUX_PKG_MAKE_PROCESSES" install

		# 5. Native synfig CLI + minimal modules for .sif -> .png icon rasterization
		cp -a "$TERMUX_PKG_SRCDIR" "$HOST_SRC"
		sed -i 's|add_subdirectory(synfig-studio)|#add_subdirectory(synfig-studio)|' "$HOST_SRC/CMakeLists.txt"
		cat << 'EOF' > "$HOST_SRC/synfig-core/src/modules/CMakeLists.txt"
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${SYNFIG_BUILD_ROOT}/lib/synfig/modules)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${SYNFIG_BUILD_ROOT}/lib/synfig/modules)
set(MODS_ENABLED lyr_std mod_filter mod_geometry mod_gradient mod_noise mod_png)
set(SYNFIG_MODULES_CONTENT "")
foreach(MOD IN ITEMS ${MODS_ENABLED})
	set(SYNFIG_MODULES_CONTENT "${SYNFIG_MODULES_CONTENT}\n${MOD}")
	add_subdirectory(${MOD})
	add_dependencies(synfig_bin ${MOD})
endforeach()
file(WRITE ${SYNFIG_BUILD_ROOT}/etc/synfig_modules.cfg ${SYNFIG_MODULES_CONTENT})
EOF

		cmake "$HOST_SRC" \
			-GNinja \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_PREFIX_PATH="$HOST_PREFIX" \
			-DCMAKE_BUILD_RPATH="$HOST_PREFIX/lib" \
			-DENABLE_TESTS=OFF
		ninja -j"$TERMUX_PKG_MAKE_PROCESSES" \
			synfig_bin lyr_std mod_filter mod_geometry mod_gradient mod_noise mod_png
	)
}

termux_step_pre_configure() {
	CXXFLAGS+=" -fno-strict-aliasing"
}
