TERMUX_PKG_HOMEPAGE=https://www.openimagedenoise.org
TERMUX_PKG_DESCRIPTION="Intel® Open Image Denoise library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_SRCURL="https://github.com/OpenImageDenoise/oidn/releases/download/v$TERMUX_PKG_VERSION/oidn-$TERMUX_PKG_VERSION.src.tar.gz"
TERMUX_PKG_SHA256=e71fd043a70f1cc80e301d1b90df6c1f536098c4dd94baa612742f6db3369c36
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libllvm, libtbb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_PLATFORM_NO_VERSIONED_SONAME=OFF"
# OIDN supports 64-bit platforms only,
# see https://github.com/OpenImageDenoise/oidn/#prerequisites.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	local ISPC_VERSION=1.30.0
	local ISPC_URL="https://github.com/ispc/ispc/releases/download/v$ISPC_VERSION/ispc-v$ISPC_VERSION-linux.tar.gz"
	local ISPC_TARFILE="$TERMUX_PKG_CACHEDIR/$(basename $ISPC_URL)"
	local ISPC_SHA256=63e7d61037849fa1ed644f0398d21740ee9f880b9bf81f017c65eebe1d42c02b
	termux_download "$ISPC_URL" "$ISPC_TARFILE" "$ISPC_SHA256"
	if [[ ! -e "$TERMUX_PKG_CACHEDIR/.placeholder-ispc-v$ISPC_VERSION" ]]; then
		rm -rf "$TERMUX_PKG_CACHEDIR/ispc-v$ISPC_VERSION-linux"
		tar -xvf "$ISPC_TARFILE" -C "$TERMUX_PKG_CACHEDIR"
		touch "$TERMUX_PKG_CACHEDIR/.placeholder-ispc-v$ISPC_VERSION"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/ispc-v$ISPC_VERSION-linux/bin:$PATH"
	LDFLAGS+=" -llog"
}
