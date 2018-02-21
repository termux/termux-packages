TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_DEPENDS="libmpdclient"
_MAIN_VERSION=0
_PATCH_VERSION=29
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SHA256=02f1daec902cb48f8cdaa6fe21c7219f6231b091dddbe437a3a4fb12cb07b9d3
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/mpc/${_MAIN_VERSION}/mpc-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
# Include some useful scripts for editing playlists
TERMUX_PKG_KEEP_SHARE_DOC=yes
# There seems to be issues with sphinx-build when using concurrent builds:
TERMUX_MAKE_PROCESSES=1
