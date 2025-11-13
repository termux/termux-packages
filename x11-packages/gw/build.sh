TERMUX_PKG_HOMEPAGE=https://github.com/kcleal/gw
TERMUX_PKG_DESCRIPTION="A browser for genomic sequencing data (.bam/.cram format)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="clealk@cardiff.ac.uk"
TERMUX_PKG_VERSION="1.2.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kcleal/gw/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4ab7afc7c8785f956e9ee32c984a5f69c4671d3025d53493a5cd9e295701dad0
TERMUX_PKG_DEPENDS="glfw, htslib, libc++, libjpeg-turbo, opengl, libcurl"
TERMUX_PKG_BUILD_DEPENDS="fontconfig, freetype, libicu, libuuid, mesa-dev, libcurl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# htslib is not available for arm.
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"

	sed -i \
		-e '/\/usr\/local\/include/d' \
		-e '/\/usr\/local\/lib/d' \
		./Makefile

	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		sed -i 's/Release-x64/Release-arm64/g' ./Makefile
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		sed -i 's/Release-x64/Release-x86/g' ./Makefile
	fi
}

termux_step_make() {
	local SKIA_URL_AARCH64="https://github.com/JetBrains/skia-build/releases/download/m93-87e8842e8c/Skia-m93-87e8842e8c-android-Release-arm64.zip"
	local SKIA_CHECKSUM_AARCH64="7286fe634cfcd499ef1232b9bdc6b08220daebde0de483639ed498a1dc1ec62e"
	local SKIA_URL_X86="https://github.com/JetBrains/skia-build/releases/download/m93-87e8842e8c/Skia-m93-87e8842e8c-android-Release-x86.zip"
	local SKIA_CHECKSUM_X86="e79868a2b791ec44673f981b68d5cb658dad3fcef97932ac7b4a80c3dd329e87"
	local SKIA_URL_X64="https://github.com/JetBrains/skia-build/releases/download/m93-87e8842e8c/Skia-m93-87e8842e8c-android-Release-x64.zip"
	local SKIA_CHECKSUM_X64="1546e41c0b2edc401639e1ed0dd32d9e8b30d478f1c4a5c345ee82f2a5e1b829"

	mkdir -p lib/skia && cd lib/skia/
	case "$TERMUX_ARCH" in
		aarch64)
			termux_download "$SKIA_URL_AARCH64" "${TERMUX_PKG_CACHEDIR}/skia-${TERMUX_ARCH}.zip" "$SKIA_CHECKSUM_AARCH64"
			;;
		i686)
			termux_download "$SKIA_URL_X86" "${TERMUX_PKG_CACHEDIR}/skia-${TERMUX_ARCH}.zip" "$SKIA_CHECKSUM_X86"
			;;
		x86_64)
			termux_download "$SKIA_URL_X64" "${TERMUX_PKG_CACHEDIR}/skia-${TERMUX_ARCH}.zip" "$SKIA_CHECKSUM_X64"
			;;
		*)
			termux_error_exit "No architecture '$TERMUX_ARCH' defined for Skia download."
			;;
	esac
	unzip -o "${TERMUX_PKG_CACHEDIR}/skia-${TERMUX_ARCH}.zip"
	cd ../../

	OLD_SKIA=1 make -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" ./gw
	install -Dm600 ./.gw.ini "${TERMUX_PREFIX}/share/doc/gw/gw.ini"
}
