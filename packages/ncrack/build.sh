TERMUX_PKG_HOMEPAGE=https://nmap.org/ncrack/
TERMUX_PKG_DESCRIPTION="high-speed network authentication cracking tool"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SHA256=4dd4abfa7c38edafd0da3a3f2ad76f9fae476e147042def87d027879444bd0b9
TERMUX_PKG_SRCURL=https://github.com/nmap/ncrack/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="openssl, openssh, openssl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_vsnprintf=no ac_cv_header_unistd=no"

termux_step_pre_configure () {
        cd nbase
        rm snprintf.c
        curl -LO https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/snprintf.c
        cd ..
        cd opensshlib
        rm cipher.c
        curl -LO https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/cipher.c
        rm explicit_bzero.c
        curl -LO https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/explicit_bzero.c
        rm bsd-snprintf.c
        curl -LO https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/bsd-snprintf.c

        sed '/explicit_bzero/d' -i *.c
}

termux_step_post_configure () {
        rm openbsd-compat.h
        curl -LO https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/openbsd-compat.h

}
