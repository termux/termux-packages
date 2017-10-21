TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/barcode/
TERMUX_PKG_DESCRIPTION="tool to convert text strings to printed bars"
TERMUX_PKG_VERSION=0.99
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/barcode/barcode-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e87ecf6421573e17ce35879db8328617795258650831affd025fba42f155cdc6
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure () {

          rm plessey.c code11.c
          wget https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/code11.c
          wget https://raw.githubusercontent.com/Auxilus/Auxilus.github.io/master/plessey.c

}
