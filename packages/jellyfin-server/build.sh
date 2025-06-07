TERMUX_PKG_HOMEPAGE="https://jellyfin.org"
TERMUX_PKG_DESCRIPTION="A free media system for organizing and streaming media (server)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	10.10.7
	7.1.1.4
)
TERMUX_PKG_SRCURL=(
	"https://github.com/jellyfin/jellyfin/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/jellyfin/jellyfin-web/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.zip"
	"https://github.com/jellyfin/jellyfin-ffmpeg/archive/refs/tags/v${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}.tar.gz"
)
TERMUX_PKG_SHA256=(
	797db59e50e33ecf85562f6c49651963bd5f00dd9cb74bf89dd905513c8207ec
	04070d4a90076f31e98ccf4d53b4c31c5556611403d9840438c64ebc3a639f75
	8dff41fe31898dc42522c4785dc86174d3dc78092666561a2c63c3541e220ddf
)
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-8.0, dotnet-targeting-pack-8.0, libcairo, pango, libjpeg-turbo, giflib, librsvg"
TERMUX_PKG_DEPENDS="libc++, aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0, libskiasharp, libesqlite3"
TERMUX_PKG_SERVICE_SCRIPT=(
	"jellyfin"
	"exec ${TERMUX_PREFIX}/bin/jellyfin 2>&1"
)
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
opt/jellyfin/include
opt/jellyfin/lib/pkgconfig
opt/jellyfin/share
"
termux_step_post_get_source() {
	pushd jellyfin-ffmpeg-"${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}"
	# If quilt is added to termux-build-helper:
	# if [[ -f "debian/patches/series" ]]; then
	# quilt push -a
	# fi
	local _patch;
	for _patch in $(<debian/patches/series); do
		git apply --whitespace=nowarn "debian/patches/${_patch}"
	done
	popd
}

termux_step_pre_configure() {
	TERMUX_PKG_DEPENDS+=", jellyfin-ffmpeg"
	termux_setup_dotnet; termux_setup_nodejs

	pushd jellyfin-web-"${TERMUX_PKG_VERSION[0]}"
	npm install

	# git warning in build log here is normal, the commit hash is not needed
	npm run build:production
	cp -R ./dist "$TERMUX_PKG_BUILDDIR/jellyfin-web"
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
		termux_error_exit  "Unsupported arch: $TERMUX_ARCH"
	fi

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
	--enable-gpl --enable-version3 --disable-ffplay --disable-debug --disable-doc --disable-sdl2 --disable-libxcb --disable-xlib --enable-lto=auto --enable-iconv --enable-zlib --enable-libfreetype --enable-libfribidi --enable-gmp --enable-libxml2 --enable-openssl --enable-lzma --enable-fontconfig --enable-libharfbuzz --enable-libvorbis --enable-opencl --enable-chromaprint --enable-libdav1d --enable-libass --enable-libbluray --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvpx --enable-libwebp --enable-libopenmpt --enable-libsrt --enable-libsvtav1 --enable-libx264 --enable-libx265 --enable-libzimg \
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
	rm -f "${TERMUX_PKG_BUILDDIR}/build/"{libe_sqlite3,libSkiaSharp,libHarfBuzzSharp}.so
	chmod 0700 "${TERMUX_PKG_BUILDDIR}/build"

	mv "${TERMUX_PKG_BUILDDIR}/jellyfin-web" "${TERMUX_PKG_BUILDDIR}/build"
	# XML cruft generated during build used to provide documentation for functions and objects
	find "${TERMUX_PKG_BUILDDIR}/build" -name '*.xml' -type f -exec rm '{}' +
	find "${TERMUX_PKG_BUILDDIR}/build" ! \( -name 'jellyfin' -o -type d \) -exec chmod 0600 '{}' \;
	find "${TERMUX_PKG_BUILDDIR}/build" \( -name 'jellyfin' -o -type d \) -exec chmod 0700 '{}' \;
	mv "${TERMUX_PKG_BUILDDIR}/build" "${TERMUX_PREFIX}/lib/jellyfin"
	ln -s "${TERMUX_PREFIX}/lib/jellyfin/jellyfin" "${TERMUX_PREFIX}/bin/jellyfin"
}
# References
# - Jellyfin-FFMPEG
# https://github.com/jellyfin/jellyfin-ffmpeg/blob/jellyfin/builder/build.sh
# https://github.com/termux/termux-packages/tree/master/packages/ffmpeg
# Note: All patches for Jellyfin-FFMPEG should be based off the patched version, see termux_step_post_get_source
# One of the source urls (jellyfin-web) points to a zip to avoid overwriting jellyfin's source archive due to duplicate filename
