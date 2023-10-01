TERMUX_PKG_HOMEPAGE=https://www.openimagedenoise.org
TERMUX_PKG_DESCRIPTION="Intel® Open Image Denoise library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/OpenImageDenoise/oidn/releases/download/v$TERMUX_PKG_VERSION/oidn-$TERMUX_PKG_VERSION.src.tar.gz
TERMUX_PKG_SHA256=3276e252297ebad67a999298d8f0c30cfb221e166b166ae5c955d88b94ad062a
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libllvm, libtbb"
# OIDN supports 64-bit platforms only and won't build on Linux ARM64, see
# https://github.com/OpenImageDenoise/oidn/issues/125#issuecomment-916479769
# and https://github.com/OpenImageDenoise/oidn/#prerequisites.
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64, arm, i686"

termux_step_pre_configure() {
	local ISPC_VERSION=1.18.0
	local ISPC_URL=https://github.com/ispc/ispc/releases/download/v$ISPC_VERSION/ispc-v$ISPC_VERSION-linux.tar.gz
	local ISPC_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $ISPC_URL)
	local ISPC_SHA256=6c379bb97962e9de7d24fd48b3f7e647dc42be898e9d187948220268c646b692
	termux_download $ISPC_URL $ISPC_TARFILE $ISPC_SHA256
	if [ ! -e "$TERMUX_PKG_CACHEDIR/.placeholder-ispc-v$ISPC_VERSION" ]; then
		rm -rf $TERMUX_PKG_CACHEDIR/ispc-v$ISPC_VERSION-linux
		tar -xvf $ISPC_TARFILE -C $TERMUX_PKG_CACHEDIR
		touch "$TERMUX_PKG_CACHEDIR/.placeholder-ispc-v$ISPC_VERSION"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/ispc-v$ISPC_VERSION-linux/bin:$PATH"
	LDFLAGS+=" -llog"
}
