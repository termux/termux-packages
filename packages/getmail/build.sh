TERMUX_PKG_HOMEPAGE=http://pyropus.ca/software/getmail/
TERMUX_PKG_DESCRIPTION="fetchmail replacement relatively easy to configure"
TERMUX_PKG_VERSION=5.8
TERMUX_PKG_SHA256=819441c7e8ef49d7036c2bc83e1568a7184f0393245fe28368a9dd310e63846e
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/getmail-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
        python2 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
        find . -path '*.pyc' -delete
}
