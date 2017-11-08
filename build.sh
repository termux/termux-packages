TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/crunch-wordlist
TERMUX_PKG_DESCRIPTION="Highly customizable wordlist generator"
TERMUX_PKG_VERSION=3.6
TERMUX_PKG_SRCURL=https://Auxilus.github.io/crunch-${TERMUX_PKG_VERSION}.tar.gz                                                                           TERMUX_PKG_SHA256=c8aa091c643bc9261f362a1a3d097c30f10669b198c8c6ba770d3dfd4f060e93
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure () {
      sed 's/-g root -o root/ /g' -i Makefile
} 
