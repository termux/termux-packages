TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=20170524
_MINOR_VERSION=
TERMUX_PKG_VERSION=${_MAJOR_VERSION}${_MINOR_VERSION}
TERMUX_PKG_SRCURL=("ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-$_MAJOR_VERSION-texmf.tar.xz" 
"ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-$_MAJOR_VERSION-extra.tar.xz"
"ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/install-tl-unx.tar.gz"
)
TERMUX_PKG_SHA256=("3f63708b77f8615ec6f2f7c93259c5f584d1b89dd335a28f2362aef9e6f0c9ec"
"afe49758c26fb51c2fae2e958d3f0c447b5cc22342ba4a4278119d39f5176d7f"
"d4e07ed15dace1ea7fabe6d225ca45ba51f1cb7783e17850bc9fe3b890239d6d"
)
TERMUX_PKG_DEPENDS="wget, perl, xz-utils, gpg, texlive-bin"
TERMUX_PKG_FOLDERNAME=("texlive-$_MAJOR_VERSION-texmf" 
"texlive-$_MAJOR_VERSION-extra"
"install-tl-$_MAJOR_VERSION" 
)
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

TL_ROOT=$TERMUX_PREFIX/opt/texlive/${TERMUX_PKG_VERSION:0:4}

