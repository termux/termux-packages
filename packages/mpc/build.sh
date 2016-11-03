pkgname=mpc
TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_DEPENDS="libmpdclient"
_MAIN_VERSION=0
_PATCH_VERSION=28
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/${pkgname}/${_MAIN_VERSION}/${pkgname}-${_MAIN_VERSION}.tar.xz
# Include some useful scripts for editing playlists
TERMUX_PKG_KEEP_SHARE_DOC=yes
