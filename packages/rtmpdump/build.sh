TERMUX_PKG_HOMEPAGE=https://rtmpdump.mplayerhq.hu/
TERMUX_PKG_DESCRIPTION="Small dumper for media content streamed over the RTMP protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6
TERMUX_PKG_REVISION=1
# Releases are not tagged.
_COMMIT=6f6bb1353fc84f4cc37138baa99f586750028a01
TERMUX_PKG_SRCURL=git+https://git.ffmpeg.org/rtmpdump
TERMUX_PKG_SHA256=b63a31cdc1f3f83558c0819a78ceee60f15ac6c32638af48d150d20f4531ce07
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_BREAKS="rtmpdump-dev"
TERMUX_PKG_REPLACES="rtmpdump-dev"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files.\nExpected: $TERMUX_PKG_SHA256\nActual:   ${s% *}"
	fi
}
