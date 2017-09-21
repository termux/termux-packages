TERMUX_PKG_HOMEPAGE=https://nmap.org/ncrack/
TERMUX_PKG_DESCRIPTION="high-speed network authentication cracking tool"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SHA256=4dd4abfa7c38edafd0da3a3f2ad76f9fae476e147042def87d027879444bd0b9
TERMUX_PKG_SRCURL=https://github.com/nmap/ncrack/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="openssl, openssh, openssl-dev"

termux_step_post_configure () {
        cd $TERMUX_PKG_SRCDIR/opensshlib
        rm cipher.c
        curl -LO https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/cipher.c
        https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/explicit_bzero.patch.c
        mv explicit_bzero.patch.c explicit_bzero.patch
        patch explicit_bzero.c < explicit_bzero.patch
        rm bsd-snprintf.c
        https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/bsd-snprintf.c
        
        sed '/explicit_bzero/d' -i /*.c
}
