TERMUX_PKG_HOMEPAGE="https://jellyfin.org"
TERMUX_PKG_DESCRIPTION="A free media system for organizing and streaming media (server)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	10.10.7
	7.0.2.9
)
TERMUX_PKG_SRCURL=(
	"https://github.com/jellyfin/jellyfin/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/jellyfin/jellyfin-ffmpeg/archive/refs/tags/v${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}.tar.gz"
)
TERMUX_PKG_SHA256=(
	797db59e50e33ecf85562f6c49651963bd5f00dd9cb74bf89dd905513c8207ec
	ae4ea57516e606a73fd2745b21284c65d41d3851d05a2ac17c425d7488192ba0
)
TERMUX_PKG_SUGGESTS="jellyfin-ffmpeg"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-8.0, dotnet-targeting-pack-8.0, libcairo, pango, libjpeg-turbo, giflib, librsvg"
TERMUX_PKG_DEPENDS="libc++, fontconfig, aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0, sqlite, libexpat, libpng, libwebp, freetype, ffmpeg"
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
	# this array is for the update-git-checksums.sh script, order should be same keys of _GIT_SHA256
	local _project=(libe_sqlite SQLitePCL.raw skiasharp jellyfin-web)
	local -A _GIT_URL=(
		[libe_sqlite]="git+https://github.com/ericsink/cb"
		[SQLitePCL.raw]="git+https://github.com/ericsink/SQLitePCL.raw"
		[skiasharp]="git+https://github.com/mono/skia"
		[jellyfin-web]="git+https://github.com/jellyfin/jellyfin-web"
	)
	local -A _GIT_COMMIT=(
		[libe_sqlite]=cd2922b8867e4360f0976601414bd24a3ad613d8
		[SQLitePCL.raw]=7521c274efb2b49855b192f17862e87964460bac
		[skiasharp]=4bed689c9c9eb77a120c6a9d54af6a572c85d1c2
		[jellyfin-web]=f4b8aa0ed4c5b571a3a6cc3bb027bb8ecebe5b68
	)
	local -A _GIT_SHA256=(
		[libe_sqlite]=1107df127ead66ace2baf92467fa10a8215371741e0b0b6a0580496ff1ae0bcf
		[SQLitePCL.raw]=8cd1b773026da818c47c693cf7a4bb81ab927b869a0ce2c6abcdbbe38d79922b
		[skiasharp]=46c733f05df257e4bec13c09b53e7ef39bb80f21acb435d206dce609f4175ab1
		[jellyfin-web]=2b8b180bdba21acc574858e50eded5fa1f7575f2571a8f17a9da7e2d9a79bb66
	)
	# this portion is required until TERMUX_PKG_SRCURL adds support for multiple git repos and duplicate filenames
	local _proj _sha256sum;
	(( ${#_GIT_URL[@]} == ${#_GIT_COMMIT[@]} && ${#_GIT_URL[@]} == ${#_GIT_SHA256[@]} )) || termux_error_exit '_GIT_URL, _GIT_COMMIT and _GIT_SHA256 must be arrays of the same length'
	for _proj in "${!_GIT_URL[@]}"; do
		# the commands until the next comment can be replaced with git clone --revision "${_GIT_COMMIT["$_proj"]}" --depth 1 in git 2.49
		mkdir "$( printf "%s" "${_GIT_URL["${_proj}"]}" | sed -E 's|^.*/(.*)$|\1|' )"
		pushd "$( printf "%s" "${_GIT_URL["${_proj}"]}" | sed -E 's|^.*/(.*)$|\1|' )"
		git init -q
		git remote add origin "${_GIT_URL["${_proj}"]:4}"
		git fetch --depth 1 origin "${_GIT_COMMIT["${_proj}"]}"
		git -c advice.detachedHead=false checkout "${_GIT_COMMIT["${_proj}"]}"
		# we need a deterministic checksum, logs get in the way
		rm -rf .git/logs
		_sha256sum="$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum | awk '{print $1}')"
		popd
		! [ "${_sha256sum}" = "${_GIT_SHA256["${_proj}"]}" ] && termux_error_exit "Error: checksums for sources do not match. To update checksums, run $(cd -- "$(dirname "$0")"; pwd)/update-git-checksums.sh"
	done

	pushd jellyfin-ffmpeg-"${TERMUX_PKG_VERSION[1]%.*}-${TERMUX_PKG_VERSION[1]##*.}"
	# If quilt is added to termux-build-helper:
	# if [[ -f "debian/patches/series" ]]; then
	# quilt push -a
	# fi
	local _patch;
	for _patch in $(<debian/patches/series); do
		git apply --whitespace=nowarn "debian/patches/${_patch}";
	done
	popd
}
termux_step_pre_configure() {
	termux_setup_dotnet; termux_setup_gn; termux_setup_nodejs
	pushd jellyfin-web
	npm install
	npm run build:production
	cp -R ./dist "$TERMUX_PKG_BUILDDIR/jellyfin-web"
	popd
	local _target_cpu=""
	case "$TERMUX_ARCH" in
		aarch64) _target_cpu="arm64" ;;
		arm) _target_cpu="arm" ;;
		x86_64) _target_cpu="x64" ;;
		i686) _target_cpu="x86" ;;
		*) termux_error_exit  "Unsupported arch: $TERMUX_ARCH"
	esac

	pushd skia
	# we must use version 62 of libjpeg-turbo
	# https://github.com/libjpeg-turbo/libjpeg-turbo/issues/795#issuecomment-2484148592
	local _flag _GN_CFLAGS _GN_LDFLAGS _GN_CPPFLAGS;
	for _flag in CFLAGS LDFLAGS CPPFLAGS; do
		declare _GN_"$_flag"="$(eval printf '%s' "\"\$$_flag\"" | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i}; printf "\"%s\"",$i}' )"
	done
	local _args_pre=""
	local _args=""
	_args_pre="target_os='android' \
	target_cpu='${_target_cpu}' \
	skia_use_icu=false \
	skia_use_harfbuzz=false \
	skia_use_piex=true \
	skia_use_sfntly=false \
	skia_enable_gpu=false \
	skia_enable_tools=false \
	skia_use_dng_sdk=false \
	skia_use_gl=false \
	skia_use_vulkan=false \
	skia_use_system_expat=true \
	skia_use_system_libjpeg_turbo=false \
	skia_use_system_freetype2=true \
	skia_use_system_libpng=true \
	skia_use_system_libwebp=true \
	skia_use_system_zlib=true \
	skia_enable_skottie=true \
	third_party_isystem=false \
	cc='$CC' \
	cxx='$CXX' \
	ar='$AR' \
	ndk='${TERMUX_STANDALONE_TOOLCHAIN}' \
	ndk_api=${TERMUX_PKG_API_LEVEL} \
	extra_asmflags=[] \
	extra_cflags=[ '-DSKIA_C_DLL', '-DHAVE_SYSCALL_GETRANDOM', '-DXML_DEV_URANDOM' ] \
	extra_ldflags=[ '-static-libstdc++', '-Wl,--no-undefined', '-Wl,-z,max-page-size=16384' ] \
	is_official_build=true \
	extra_asmflags+=[ '-no-integrated-as', '-I${TERMUX_PREFIX}/include' ] \
	extra_cflags+=[ '-Wno-macro-redefined', ${_GN_CPPFLAGS}, ${_GN_CFLAGS}, $(pkg-config --cflags freetype2 libpng libwebp expat | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i}; printf "\"%s\"",$i}') ] \
	extra_ldflags+=[ ${_GN_LDFLAGS}, $(pkg-config --libs freetype2 libpng libwebp expat | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i}; printf "\"%s\"",$i}') ]"
	_args="$(printf "%s\n" "${_args_pre}" | sed "s/'/\"/g" | sed 's/\t//g')"

	./tools/git-sync-deps
	gn gen 'out' --args="${_args}"
	ninja -C out SkiaSharp

	_args_pre="target_os='android' \
	target_cpu='${_target_cpu}' \
	visibility_hidden=false \
	cc='$CC' \
	cxx='$CXX' \
	ar='$AR' \
	ndk='${TERMUX_STANDALONE_TOOLCHAIN}' \
	ndk_api=${TERMUX_PKG_API_LEVEL} \
	extra_asmflags=[] \
	extra_cflags=[] \
	extra_ldflags=[ '-static-libstdc++', '-Wl,--no-undefined', '-Wl,-z,max-page-size=16384' ] \
	is_official_build=true \
	extra_asmflags+=[ '-no-integrated-as', '-I${TERMUX_PREFIX}/include' ] \
	extra_cflags+=[ '-Wno-macro-redefined', ${_GN_CPPFLAGS}, ${_GN_CFLAGS} ] \
	extra_ldflags+=[ ${_GN_LDFLAGS} ]"
	_args="$(printf "%s\n" "${_args_pre}" | sed "s/'/\"/g" | sed 's/\t//g')"

	gn gen 'out' --args="${_args}"
	ninja -C out HarfBuzzSharp

	cp out/libSkiaSharp.so out/libHarfBuzzSharp.so "$TERMUX_PKG_BUILDDIR"
	popd

#	if [ "$TERMUX_ARCH" = "arm" ]; then
#		_target_cpu="armhf"
#	fi
	local _tmpdir="$(mktemp -d "${TMPDIR-/tmp}/termux.src.dotnetproj.XXXXXXXX")"
	[ -d "${_tmpdir}" ] || termux_error_exit "mktemp failed"
	# dotnet traverses up to find a project root, which is bad for us
	# SQLitePCL.raw needs it at "../cb"
	mv "cb" "${_tmpdir}/cb"
	mv "SQLitePCL.raw" "${_tmpdir}/SQLitePCL.raw"
	pushd "${_tmpdir}/SQLitePCL.raw"
	dotnet tool install --global dotnet-t4
	( cd gen_providers; dotnet run )
	cd src/SQLitePCLRaw.lib.e_sqlite3 && dotnet pack -c Release
	cd ../SQLitePCLRaw.bundle_e_sqlite3 && dotnet build -p:TargetFrameworks=net8.0
	cd "${_tmpdir}"
	pushd "cb/bld" && dotnet run && "$CC" @linux_e_sqlite3_"${_target_cpu}".gccargs -lm -ldl; popd
	cp "cb/bld/bin/e_sqlite3/linux/${_target_cpu}/libe_sqlite3.so" SQLitePCL.raw/src/SQLitePCLRaw.bundle_e_sqlite3/bin/Debug/net8.0/*dll "$TERMUX_PKG_BUILDDIR"
	popd # $TERMUX_PKG_SRCDIR
	rm -rf "$_tmpdir"

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
	--enable-gpl --enable-version3 --disable-ffplay --disable-debug --disable-doc --disable-ptx-compression --disable-sdl2 --disable-libxcb --disable-xlib --enable-lto=auto --enable-iconv --enable-zlib --enable-libfreetype --enable-libfribidi --enable-gmp --enable-libxml2 --enable-openssl --enable-lzma --enable-fontconfig --enable-libharfbuzz --enable-libvorbis --enable-opencl --enable-chromaprint --enable-libdav1d --enable-libass --enable-libbluray --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvpx --enable-libwebp --enable-libopenmpt --enable-libsrt --enable-libsvtav1 --enable-libdrm --enable-libx264 --enable-libx265 --enable-libzimg \
	${_EXTRA_CONFIGURE_FLAGS} \
	--disable-vulkan

	make -j"$TERMUX_PKG_MAKE_PROCESSES"
	make install
	popd
}

termux_step_make() {
	dotnet publish "$TERMUX_PKG_SRCDIR"/Jellyfin.Server --configuration Release --runtime "$DOTNET_TARGET_NAME" --output "$TERMUX_PKG_BUILDDIR"/build --no-self-contained -p:DebugType=None
}

termux_step_make_install() {
	chmod 0700 "${TERMUX_PKG_BUILDDIR}/build"
	find "${TERMUX_PKG_BUILDDIR}/build" -name '*.xml' -type f -exec rm '{}' +
	find "$TERMUX_PKG_BUILDDIR" -maxdepth 1 \( -type f -o -name 'jellyfin-web' \) -exec mv -t "${TERMUX_PKG_BUILDDIR}/build" '{}' +
	find "${TERMUX_PKG_BUILDDIR}/build" ! \( -name '*.so' -o -name 'jellyfin' -o -type d \) -exec chmod 0600 '{}' \;
	find "${TERMUX_PKG_BUILDDIR}/build" \( -name 'jellyfin' -o -name '*.so' -o -type d \) -exec chmod 0700 '{}' \;
	mv "${TERMUX_PKG_BUILDDIR}/build" "${TERMUX_PREFIX}/lib/jellyfin"
	ln -s "${TERMUX_PREFIX}/lib/jellyfin/jellyfin" "${TERMUX_PREFIX}/bin/jellyfin"
}
# References
# - SkiaSharp
# https://cgit.freebsd.org/ports/tree/graphics/libskiasharp
# https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=282704
# https://github.com/mono/SkiaSharp/blob/release/2.88.9/native/android/build.cake
# https://gn.googlesource.com/gn/+/main/docs/reference.md
# - Jellyfin-FFMPEG
# https://github.com/jellyfin/jellyfin-ffmpeg/blob/jellyfin/builder/build.sh
# https://github.com/termux/termux-packages/tree/master/packages/ffmpeg
# Note: All patches for Jellyfin-FFMPEG should be based off the patched version, see termux_step_post_get_source
