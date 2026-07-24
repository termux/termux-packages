TERMUX_PKG_HOMEPAGE="https://jellyfin.org"
TERMUX_PKG_DESCRIPTION="A free media system for organizing and streaming media (server)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	12.0~rc3
	7.1.4.3
)
_JELLYFIN_VERSION="${TERMUX_PKG_VERSION[0]}"
TERMUX_PKG_SRCURL=(
	"https://github.com/jellyfin/jellyfin/archive/refs/tags/v${_JELLYFIN_VERSION//\~/-}.tar.gz"
	"https://github.com/jellyfin/jellyfin-web/archive/refs/tags/v${_JELLYFIN_VERSION//\~/-}.zip"
	"https://github.com/jellyfin/jellyfin-ffmpeg/archive/refs/tags/v${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}.tar.gz"
)
TERMUX_PKG_SHA256=(
	73582ed7c46bcf6953e51f7d4e68745ac70858233c640a71302480bd86c734d1
	d082d1d6c898a837940684aa283e43b657a9ba1eb6b4cd2aafb43dae5a217756
	38fff90f73b3c4f9c3c7270711411a4ec3cbe63b205d4b4a5525bcc532d3d31f
)
TERMUX_PKG_DEPENDS="aspnetcore-runtime-10.0, dotnet-host, dotnet-runtime-10.0, libskiasharp (>= 3.119), libskiasharp (<< 4), libesqlite3, jellyfin-ffmpeg"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-10.0, dotnet-targeting-pack-10.0, libcairo, pango, libjpeg-turbo, giflib, librsvg"
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
opt/jellyfin/include
opt/jellyfin/lib/pkgconfig
opt/jellyfin/share
var
"
termux_step_post_get_source() {
	pushd jellyfin-ffmpeg-"${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}"
	# If quilt is added to termux-build-helper:
	# if [[ -f "debian/patches/series" ]]; then
	# quilt push -a
	# fi
	local _patch
	for _patch in $(<debian/patches/series); do
		git apply --whitespace=nowarn "debian/patches/${_patch}"
	done
	popd
}

termux_step_pre_configure() {
	TERMUX_DOTNET_VERSION=10.0
	termux_setup_dotnet
	termux_setup_nodejs

	pushd jellyfin-web-"${_JELLYFIN_VERSION//\~/-}"
	npm install

	# Replace git describe in webpack.common.js with exact version string to prevent git status 128 errors when building from source tarballs
	sed -i "s/execSync('git describe --always --dirty')/execSync('echo v${_JELLYFIN_VERSION//\~/-}')/g" webpack.common.js

	# git warning in build log here is normal, the commit hash is not needed
	npm run build:production
	cp -R ./dist "$TERMUX_PKG_BUILDDIR/jellyfin-web"

	# ~1GiB cleanup
	rm -rf ./node_modules
	popd

	pushd jellyfin-ffmpeg-"${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}"
	local _ARCH=""
	local _FFMPEG_PREFIX="${TERMUX_PREFIX}/opt/jellyfin"
	LDFLAGS="-Wl,-rpath=${_FFMPEG_PREFIX}/lib ${LDFLAGS}"

	local _EXTRA_CONFIGURE_FLAGS=""
	if [ "$TERMUX_ARCH" = "i686" ]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
		#	elif [ "$TERMUX_ARCH" = "arm" ]; then
		#		_ARCH="armeabi-v7a"
		#		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_ARCH="x86_64"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_ARCH="$TERMUX_ARCH"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	_EXTRA_CONFIGURE_FLAGS+=" --disable-indev=android_camera"

	# generated using ffmpeg-configureopts.sh
	# if names of variables used in this command are changed, please update variable names in ffmpeg-configureopts.sh as well
	./configure --prefix="${_FFMPEG_PREFIX}" \
		--arch="${_ARCH}" \
		--as="$AS" \
		--cc="$CC" \
		--cxx="$CXX" \
		--nm="$NM" \
		--ar="$AR" \
		--ranlib=llvm-ranlib \
		--pkg-config="$PKG_CONFIG" \
		--strip="$STRIP" \
		--enable-cross-compile \
		--extra-version="Jellyfin" \
		--extra-cflags="" \
		--extra-cxxflags="" \
		--extra-ldflags="" \
		--extra-ldexeflags="-pie" \
		--extra-libs="-ldl -landroid-glob" \
		--target-os=android \
		--disable-static \
		--enable-shared \
		--enable-gpl \
		--enable-version3 \
		--disable-ffplay \
		--disable-debug \
		--disable-doc \
		--disable-sdl2 \
		--disable-libxcb \
		--disable-xlib \
		--enable-lto=auto \
		--enable-iconv \
		--enable-zlib \
		--enable-libfreetype \
		--enable-libfribidi \
		--enable-gmp \
		--enable-libxml2 \
		--enable-openssl \
		--enable-lzma \
		--enable-fontconfig \
		--enable-libharfbuzz \
		--enable-libvorbis \
		--enable-opencl \
		--enable-chromaprint \
		--enable-libdav1d \
		--enable-libass \
		--enable-libbluray \
		--enable-libmp3lame \
		--enable-libopus \
		--enable-libtheora \
		--enable-libvpx \
		--enable-libwebp \
		--enable-libopenmpt \
		--enable-libsrt \
		--enable-libsvtav1 \
		--enable-libx264 \
		--enable-libx265 \
		--enable-libzimg \
		${_EXTRA_CONFIGURE_FLAGS} \
		--disable-vulkan

	make -j"$TERMUX_PKG_MAKE_PROCESSES"
	make install
	popd
}

termux_step_make() {
	dotnet publish "$TERMUX_PKG_SRCDIR"/Jellyfin.Server --configuration Release --runtime "$DOTNET_TARGET_NAME" --output "$TERMUX_PKG_BUILDDIR"/build --no-self-contained -p:DebugType=None
	dotnet build-server shutdown
}

termux_step_make_install() {
	# we provide bionic builds of these in the repo
	rm -f "${TERMUX_PKG_BUILDDIR}/build/"{libe_sqlite3,libSkiaSharp,libHarfBuzzSharp}.so*
	chmod 0700 "${TERMUX_PKG_BUILDDIR}/build"

	mv "${TERMUX_PKG_BUILDDIR}/jellyfin-web" "${TERMUX_PKG_BUILDDIR}/build"
	# XML cruft generated during build used to provide documentation for functions and objects
	find "${TERMUX_PKG_BUILDDIR}/build" -name '*.xml' -type f -exec rm '{}' +
	find "${TERMUX_PKG_BUILDDIR}/build" ! \( -name 'jellyfin' -o -type d \) -exec chmod 0600 '{}' \;
	find "${TERMUX_PKG_BUILDDIR}/build" \( -name 'jellyfin' -o -type d \) -exec chmod 0700 '{}' \;
	rm -rf "${TERMUX_PREFIX}/lib/jellyfin"
	mv "${TERMUX_PKG_BUILDDIR}/build" "${TERMUX_PREFIX}/lib/jellyfin"

	mkdir -p "${TERMUX_PREFIX}/bin"
	ln -sf "${TERMUX_PREFIX}/lib/jellyfin/jellyfin" "${TERMUX_PREFIX}/bin/jellyfin"
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}/var/service/jellyfin/log"
	ln -sf "${TERMUX_PREFIX}/share/termux-services/svlogger" "${TERMUX_PREFIX}/var/service/jellyfin/log/run"

	cat <<- EOF > "${TERMUX_PREFIX}/var/service/jellyfin/run"
		#!${TERMUX_PREFIX}/bin/sh
		OLD_DATA_DIR="\$HOME/.local/share/jellyfin"
		NEW_DATA_DIR="\$HOME/jellyfin"

		if pgrep -f "jellyfin.dll" >/dev/null 2>&1; then
			pkill -9 -f "jellyfin.dll" 2>/dev/null || true
			sleep 1
		fi

		if [ -d "\$OLD_DATA_DIR" ] && [ ! -d "\$NEW_DATA_DIR/data" ]; then
			echo '[jellyfin-migrate] Detected v10.11 data at '\$OLD_DATA_DIR' — migrating to '\$NEW_DATA_DIR'...'
			mkdir -p "\$NEW_DATA_DIR/config" "\$NEW_DATA_DIR/data"
			if [ -d "\$HOME/.config/jellyfin" ]; then
				cp -rf "\$HOME/.config/jellyfin/." "\$NEW_DATA_DIR/config/"
			fi
			cp -rf "\$OLD_DATA_DIR/." "\$NEW_DATA_DIR/"
		fi

		if [ -d "\$NEW_DATA_DIR/plugins" ] && [ ! -f "\$NEW_DATA_DIR/.v12_plugins_backed_up" ]; then
			echo '[jellyfin-migrate] Backing up legacy v10.11 plugins to plugins_v10.11_backup...'
			mv "\$NEW_DATA_DIR/plugins" "\$NEW_DATA_DIR/plugins_v10.11_backup"
			mkdir -p "\$NEW_DATA_DIR/plugins"
			touch "\$NEW_DATA_DIR/.v12_plugins_backed_up"
		fi

		if command -v sqlite3 >/dev/null 2>&1 && [ -f "\$NEW_DATA_DIR/data/jellyfin.db" ]; then
			sqlite3 "\$NEW_DATA_DIR/data/jellyfin.db" "UPDATE BaseItems SET Path = REPLACE(Path, '\$OLD_DATA_DIR', '\$NEW_DATA_DIR') WHERE Path LIKE '\$OLD_DATA_DIR%';" 2>/dev/null || true
		fi

		exec ${TERMUX_PREFIX}/bin/jellyfin --datadir "\$NEW_DATA_DIR" 2>&1
	EOF

	chmod 0700 "${TERMUX_PREFIX}/var/service/jellyfin/run"
}
