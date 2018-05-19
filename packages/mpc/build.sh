TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_DEPENDS="libmpdclient"
_MAIN_VERSION=0
_PATCH_VERSION=30
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SHA256=65fc5b0a8430efe9acbe6e261127960682764b20ab994676371bdc797d867fce
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/mpc/${_MAIN_VERSION}/mpc-${_MAIN_VERSION}.${_PATCH_VERSION}.tar.xz
# Include some useful scripts for editing playlists
TERMUX_PKG_KEEP_SHARE_DOC=yes
# There seems to be issues with sphinx-build when using concurrent builds:
TERMUX_MAKE_PROCESSES=1
