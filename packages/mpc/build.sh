TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_DEPENDS="libmpdclient"
_MAIN_VERSION=0
_PATCH_VERSION=28
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/mpc/${_MAIN_VERSION}/mpc-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
TERMUX_PKG_SHA256=a4337d06c85dc81a638821d30fce8a137a58d13d510be34a11c1cce95cabc547
# Include some useful scripts for editing playlists
TERMUX_PKG_KEEP_SHARE_DOC=yes
