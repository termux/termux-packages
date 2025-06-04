TERMUX_PKG_HOMEPAGE=https://www.openimagedenoise.org
TERMUX_PKG_DESCRIPTION="Intel® Open Image Denoise library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_SRCURL=https://github.com/OpenImageDenoise/oidn/releases/download/v$TERMUX_PKG_VERSION/oidn-$TERMUX_PKG_VERSION.src.tar.gz
TERMUX_PKG_SHA256=ccf221535b4007607fb53d3ff5afa74de25413bb8ef5d03d215f46c7cc2f96cf
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libllvm, libtbb"
# OIDN supports 64-bit platforms only,
# see https://github.com/OpenImageDenoise/oidn/#prerequisites.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	local ISPC_VERSION=1.27.0
	local ISPC_URL=https://github.com/ispc/ispc/releases/download/v$ISPC_VERSION/ispc-v$ISPC_VERSION-linux.tar.gz
	local ISPC_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $ISPC_URL)
	local ISPC_SHA256=e9c3c653ff3241fce8e2f5c2f26fc1d8e80b8dd73a135bc59627221c00f4d30a
	termux_download $ISPC_URL $ISPC_TARFILE $ISPC_SHA256
	if [ ! -e "$TERMUX_PKG_CACHEDIR/.placeholder-ispc-v$ISPC_VERSION" ]; then
		rm -rf $TERMUX_PKG_CACHEDIR/ispc-v$ISPC_VERSION-linux
		tar -xvf $ISPC_TARFILE -C $TERMUX_PKG_CACHEDIR
		touch "$TERMUX_PKG_CACHEDIR/.placeholder-ispc-v$ISPC_VERSION"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/ispc-v$ISPC_VERSION-linux/bin:$PATH"
	LDFLAGS+=" -llog"
}
