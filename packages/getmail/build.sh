TERMUX_PKG_HOMEPAGE=http://pyropus.ca/software/getmail/
TERMUX_PKG_DESCRIPTION="fetchmail replacement relatively easy to configure"
TERMUX_PKG_VERSION=5.7
TERMUX_PKG_SHA256=2497a669e77c929621826240371b57b8157502bb88ae530c30307b09233afbf9
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
