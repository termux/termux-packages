TERMUX_PKG_HOMEPAGE="https://jellyfin.org"
TERMUX_PKG_DESCRIPTION="A free media system for organizing and streaming media (server)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	10.11.5
	7.1.3.1
)
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=(
	"https://github.com/jellyfin/jellyfin/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/jellyfin/jellyfin-web/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.zip"
	"https://github.com/jellyfin/jellyfin-ffmpeg/archive/refs/tags/v${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}.tar.gz"
)
TERMUX_PKG_SHA256=(
	f6021e914502f6300ba862e3adb2bd013f6243b67ac8654002d8724b106b2831
	4f31a4c37b1cda6013beb379e2ef8882dc2b8fa182dd6cdc5bb6fec54a543edd
	2e869699fe2ec73649ba2579a904ec737e19555549bf789d8769a854e9179d8c
)
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-9.0, dotnet-targeting-pack-9.0, libcairo, pango, libjpeg-turbo, giflib, librsvg"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-9.0, dotnet-host, dotnet-runtime-9.0, libskiasharp, libesqlite3, jellyfin-ffmpeg"
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
	TERMUX_DOTNET_VERSION=9.0
	termux_setup_dotnet; termux_setup_nodejs

	pushd jellyfin-web-"${TERMUX_PKG_VERSION[0]}"
	npm install

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
	rm -f "${TERMUX_PKG_BUILDDIR}/build/"{libe_sqlite3,libSkiaSharp,libHarfBuzzSharp}.so*
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
